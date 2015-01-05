FactoryGirl.define do 
  factory :student, class: User do
    username "Student"
    password "password"
    email { "#{username}@#{username}.com" }
    user_type "Student"
  end
  
  factory :teacher, class: User do 
    username "Teacher"
    password "password"
    email { "#{username}@#{username}.com" }
    user_type "Teacher"
  end
  
  factory :admin, class: User do
    username "Admin"
    password "password"
    email { "#{username}@#{username}.com" }
    user_type "Admin"
  end
end