class CourseStudents < ActiveRecord::Base
  validates :course, :student, presence: true
  validates :course, uniqueness: { scope: :student }
  
  after_create :ensure_teacher_student_link
  
  belongs_to :course, inverse_of: :links_with_students
  
  belongs_to :student,
    class_name: "User",
    foreign_key: :student_id,
    inverse_of: :links_with_taken_courses
  
  private  
  def ensure_teacher_student_link
    teacher_id = self.course.teacher_id
    student_id = self.student_id
    TeacherStudentLink.create(teacher_id: teacher_id, student_id: student_id) #doesn't error out if already exists
  end
end
