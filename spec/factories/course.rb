FactoryGirl.define do 
  factory :course, class: Course do
    teacher
    title "Course"
  end
end