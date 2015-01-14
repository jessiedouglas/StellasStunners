class Problem < ActiveRecord::Base
  validates :title, :body, :solution, presence: true
  validates :is_original, inclusion: { in: [true, false] }
  
  belongs_to :creator,
    class_name: "User",
    foreign_key: :creator_id,
    inverse_of: :created_problems
  
  has_many :links_with_assignments, 
    class_name: "AssignmentProblem",
    foreign_key: :problem_id,
    inverse_of: :problem,
    dependent: :destroy
    
  has_many :assignments, through: :links_with_assignments, source: :assignment
  
  def in_use?
    other_user_count = AssignmentProblem.joins(:assignment)
                                .where("assignment_problems.problem_id = ?", self.id)
                                .where("assignments.teacher_id != ?", current_user.id)
                                .count
    
    other_user_count > 0
  end
end
