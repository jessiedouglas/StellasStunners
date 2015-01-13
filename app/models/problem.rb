class Problem < ActiveRecord::Base
  validates :title, :body, :solution, presence: true
  validates :is_original, inclusion: { in: [true, false] }
  
  has_many :links_with_assignments, 
    class_name: "AssignmentProblem",
    foreign_key: :problem_id,
    inverse_of: :problem,
    dependent: :destroy
    
  has_many :assignments, through: :links_with_assignments, source: :assignment
end
