FactoryGirl.define do
  factory :assignment, class: Assignment do
    teacher
    title "Title"
  end
end