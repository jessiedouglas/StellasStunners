class User < ActiveRecord::Base
  validates :username, :email, :user_type, :password_digest, :session_token, presence: true
  validates :username, :email, uniqueness: true
  validates :user_type, inclusion: { in: ["Student", "Teacher", "Admin"] }
  validates :password, length: { minimum: 8, allow_nil: true }
  
  after_initialize :ensure_session_token
  
  attr_reader :password
  
  has_many :links_with_students,
    class_name: "TeacherStudentLink",
    foreign_key: :teacher_id,
    inverse_of: :teacher,
    dependent: :destroy
    
  has_many :links_with_teachers,
    class_name: "TeacherStudentLink",
    foreign_key: :student_id,
    inverse_of: :student,
    dependent: :destroy
    
  has_many :students, through: :links_with_students, source: :student
  
  has_many :teachers, through: :links_with_teachers, source: :teacher
  
  has_many :taught_courses,
     class_name: "Course",
     foreign_key: :teacher_id,
     inverse_of: :teacher,
     dependent: :destroy
     
  has_many :links_with_taken_courses,
    class_name: "CourseStudents",
    foreign_key: :student_id,
    inverse_of: :student,
    dependent: :destroy
    
  has_many :taken_courses, through: :links_with_taken_courses, source: :course
  
  def self.generate_session_token
    loop do
      token = SecureRandom::urlsafe_base64(16)
      if !User.find_by_session_token(token)
        return token
      end
    end
  end
  
  def self.find_by_credentials(un_or_email, password)
    user = User.find_by_username_or_email(un_or_email)
    return nil if user.nil?
    
    return user if user.is_password?(password)
    
    nil
  end
  
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
  
  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
  
  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end
  
  private
  def self.find_by_username_or_email(un_or_email)
    user = User.find_by_username(un_or_email)
    return user unless user.nil?
    
    User.find_by_email(un_or_email)
  end
  
  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end
end
