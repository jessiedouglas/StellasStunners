FactoryGirl.define do 
  factory :teacher_student_link, class: TeacherStudentLink do
    teacher
    student
  end
end