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
  
  def in_use?(user)
    other_user_count = AssignmentProblem.joins(:assignment)
                                .where("assignment_problems.problem_id = ?", self.id)
                                .where("assignments.teacher_id != ?", user.id)
                                .count
    
    other_user_count > 0
  end
  
  def ensure_problem_links_changed(old_problem, user)
    #when a user edits a problem that is being used in others' assignments, we want the problem to be changed on all
    #the original user's assignments, but not on the others'.
    in_user_assignments = Hash.new { false }
    user.created_assignments.each do |assignment|
      in_user_assignments[assignment.id] = true
    end
    
    links_to_change = old_problem.links_with_assignments.select { |link| in_user_assignments[link.assignment_id] }
    
    links_to_change.each do |link|
      AssignmentProblem.create!(assignment_id: link.assignment_id, problem: self)
      link.destroy
    end
  end
end
