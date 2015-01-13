class StudentAssignmentLink < ActiveRecord::Base
  validates :assignment, :student, presence: true
  
  belongs_to :student,
    class_name: "User",
    foreign_key: :student_id,
    inverse_of: :links_with_assigned_assignments
    
  belongs_to :assignment, inverse_of: :links_with_students
end
