teachers = []
students = []
courses = []

teachers << User.create(name: "McGonagall", email: "MacGonagall@teacher.com", password: "password", user_type: "Teacher")
teachers << User.create(name: "Snape", email: "Snape@teacher.com", password: "password", user_type: "Teacher")
students << User.create(name: "HarryPotter", email: "HarryPotter@student.com", password: "password", user_type: "Student")
students << User.create(name: "RonWeasley", email: "RonWeasley@student.com", password: "password", user_type: "Student")

10.times do 
  name = Faker::Name.first_name + Faker::Name.last_name
  user = User.create!(name: name, email: "#{name}@teacher.com", password: "password", user_type: "Teacher")
  teachers << user
end

50.times do 
  name = Faker::Name.first_name + Faker::Name.last_name
  user = User.create!(name: name, email: "#{name}@student.com", password: "password", user_type: "Student")
  students << user
end

teachers.each do |teacher|
  2.times do |n|
    course = teacher.taught_courses.create!(title: "#{teacher.name} Course #{n + 1}", teacher: teacher)
    courses << course
  end
end

students.each do |student|
  n1 = rand(courses.length)
  n2 = rand(courses.length - 1) + 1
  
  link1 = student.links_with_taken_courses.create!(course: courses[n1])
  link2 = student.links_with_taken_courses.create!(course: courses[(n1 + n2) % courses.length])
  
  student_teachers = student.teachers
  teacher = teachers[rand(teachers.length)]
  loop do
    break unless student_teachers.include?(teacher)
    teacher = teachers[rand(teachers.length)]
  end
  
  student.links_with_teachers.create!(teacher: teacher)
end