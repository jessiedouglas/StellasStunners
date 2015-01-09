class Course < ActiveRecord::Base
  validates :teacher, :title, :course_code, presence: true
  validates :teacher, uniqueness: { scope: :title }
  validates :course_code, uniqueness: true
  
  after_initialize :ensure_course_code
    
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
    self.course_code ||= CodeGenerator::Generator.generate(uniqueness: { model: :course, field: :course_code }, length: 6)
  end
end
