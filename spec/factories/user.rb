FactoryGirl.define do 
  factory :student, class: User do
    name "Student"
    password "password"
    email { "#{name}@student.com" }
    user_type "Student"
  end
  
  factory :teacher, class: User do
    name "Teacher"
    password "password"
    email { "#{name}@teacher.com" }
    user_type "Teacher"
  end
  
  factory :admin, class: User do
    name "Admin"
    password "password"
    email { "#{name}@admin.com" }
    user_type "Admin"
  end
end