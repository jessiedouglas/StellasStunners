class User < ActiveRecord::Base
  validates :name, :email, :user_type, :password_digest, :session_token, presence: true
  validates :email, uniqueness: true
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
  
  def self.find_by_credentials(email, password)
    user = User.find_by_email(email)
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
  
  def sort_students_by_course
    courses = self.taught_courses.includes(:students)
    students = self.students
    course_hash = Hash.new { [] }
    seen = Hash.new { false }
    
    courses.each do |course|
      course.students.includes(:links_with_teachers).each do |student|
        course_hash[course] += [student]
        seen[student] = true
      end
    end
    
    students.each do |student|
      next if seen[student]
      course_hash["None"] += [student]
    end
    
    course_hash
  end
  
  def sort_courses
    courses = self.taught_courses.to_a
    courses.sort! { |x, y| x.title <=> y.title }
    courses = ["None"] + courses
  end
  
  private
  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end
end
