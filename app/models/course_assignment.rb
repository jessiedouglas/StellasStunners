class CourseAssignment < ActiveRecord::Base
  validates :course, :assignment, presence: true
  validates :assignment, uniqueness: { scope: :course }
  validate :ensure_same_teacher
  
  after_create :ensure_student_assignment_links
  before_destroy :ensure_student_assignment_links_destroyed
  
  belongs_to :course, inverse_of: :links_with_assignments
  belongs_to :assignment, inverse_of: :links_with_courses
  
  private
  def ensure_student_assignment_links
    self.course.students.each do |student|
      StudentAssignmentLink.create!(student: student, assignment_id: self.assignment_id)
    end
  end
  
  def ensure_same_teacher
    unless self.course.teacher == self.assignment.teacher
      errors[:base] << "Can't link assignment and course with different teachers."
    end
  end
  
  def ensure_student_assignment_links_destroyed
    assignment = self.assignment
    
    self.course.students.each do |student|
      link = StudentAssignmentLink.where("student_id = ? AND assignment_id = ?", student.id, assignment.id).first
      StudentAssignmentLink.destroy(link.id)
    end
  end
end
