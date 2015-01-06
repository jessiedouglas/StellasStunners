class Course < ActiveRecord::Base
  validates :teacher, :title, presence: true
  validates :teacher, uniqueness: { scope: :title }
  
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
end
