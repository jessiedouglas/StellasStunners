FactoryGirl.define do
  factory :student_assignment_link, class: StudentAssignmentLink do
    assignment
    student
  end
end