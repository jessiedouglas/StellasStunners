class AssignmentProblem < ActiveRecord::Base
  validates :assignment, :problem, presence: true
  validates :problem, uniqueness: { scope: :assignment }
  
  belongs_to :assignment, inverse_of: :links_with_problems
  belongs_to :problem, inverse_of: :links_with_assignments
end
