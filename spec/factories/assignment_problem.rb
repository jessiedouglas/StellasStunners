FactoryGirl.define do
  factory :assignment_problem, class: AssignmentProblem do
    assignment
    problem
  end
end