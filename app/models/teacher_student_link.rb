class TeacherStudentLink < ActiveRecord::Base
  validates :teacher, :student, presence: true
  validates :teacher, uniqueness: { scope: :student }
  
  belongs_to :teacher,
    class_name: "User",
    foreign_key: :teacher_id,
    inverse_of: :links_with_students
  
  belongs_to :student,
    class_name: "User",
    foreign_key: :student_id,
    inverse_of: :links_with_teachers
end
