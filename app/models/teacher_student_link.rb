class TeacherStudentLink < ActiveRecord::Base
  validates :teacher, :student, presence: true
  validates :teacher, uniqueness: { scope: :student }
  
  before_destroy :ensure_student_removed_from_courses
  
  belongs_to :teacher,
    class_name: "User",
    foreign_key: :teacher_id,
    inverse_of: :links_with_students
  
  belongs_to :student,
    class_name: "User",
    foreign_key: :student_id,
    inverse_of: :links_with_teachers
    
  private
  def ensure_student_removed_from_courses
    course_links = Course.joins("INNER JOIN course_students ON courses.id = course_students.course_id")
                        .where(courses: { teacher_id: self.teacher_id })
                        .where(course_students: { student_id: self.student_id })
                        .select("course_students.id")
    
    course_links.each do |id|
      CourseStudents.find(id).destroy
    end   
  end
end
