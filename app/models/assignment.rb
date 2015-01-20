class Assignment < ActiveRecord::Base
  validates :teacher, :title, presence: true
  
  belongs_to :teacher,
    class_name: "User",
    foreign_key: :teacher_id,
    inverse_of: :created_assignments
    
  has_many :links_with_students,
    class_name: "StudentAssignmentLink",
    foreign_key: :assignment_id,
    inverse_of: :assignment,
    dependent: :destroy
    
  has_many :students, through: :links_with_students, source: :student
  
  has_many :links_with_problems,
    class_name: "AssignmentProblem",
    foreign_key: :assignment_id,
    inverse_of: :assignment,
    dependent: :destroy
  
  has_many :problems, through: :links_with_problems, source: :problem
end
