class Course < ActiveRecord::Base
  validates :teacher, :title, :course_code, presence: true
  validates :teacher, uniqueness: { scope: :title }
  validates :course_code, uniqueness: true
  
  before_validation :ensure_course_code
    
  belongs_to :teacher,
    class_name: "User",
    foreign_key: :teacher_id,
    inverse_of: :taught_courses
    
  has_many :links_with_students,
    class_name: "CourseStudents",
    foreign_key: :course_id,
    inverse_of: :course,
    dependent: :destroy
    
  has_many :students, through: :links_with_students, source: :student
  
  private
  def ensure_course_code
    return if self.course_code 
    
    all_codes = Course.all.map { |course| course.course_code }
    
    loop do
      code = CodeGenerator::Generator.generate(length: 6)
      unless all_codes.include?(code)
        self.course_code = code
        return
      end
    end
  end
end
