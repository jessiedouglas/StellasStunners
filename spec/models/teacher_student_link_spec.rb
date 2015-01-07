require 'spec_helper'

describe TeacherStudentLink do
  it "allows a standard link" do
    tsl = FactoryGirl.build(:teacher_student_link)
    expect(tsl).to be_valid
  end
  
  it "doesn't allow combo duplicates" do
    teacher = FactoryGirl.create(:teacher)
    student = FactoryGirl.create(:student)
    FactoryGirl.create(:teacher_student_link, teacher: teacher, student: student)
    tsl = FactoryGirl.build(:teacher_student_link, teacher: teacher, student: student)
    
    expect(tsl).to_not be_valid
  end
  
  it "allows individual duplicates" do
    teacher1 = FactoryGirl.create(:teacher, name: "Minerva McGonagall")
    teacher2 = FactoryGirl.create(:teacher, name: "Severus Snape")
    student1 = FactoryGirl.create(:student, name: "Harry Potter")
    student2 = FactoryGirl.create(:student, name: "Draco Malfoy")
    FactoryGirl.create(:teacher_student_link, teacher: teacher1, student: student1)
    
    tsl1 = FactoryGirl.build(:teacher_student_link, teacher: teacher1, student: student2)
    tsl2 = FactoryGirl.build(:teacher_student_link, teacher: teacher2, student: student1)
    
    expect(tsl1).to be_valid
    expect(tsl2).to be_valid
  end
  
  it "properly links to the correct model" do
    teacher = FactoryGirl.create(:teacher, name: "Minerva McGonagall")
    student = FactoryGirl.create(:student, name: "Harry Potter")
    link = FactoryGirl.create(:teacher_student_link, teacher: teacher, student: student)
    
    expect(link.teacher).to eq(teacher)
    expect(link.student).to eq(student)
  end
  
  it "destroys itself when a student or teacher is destroyed" do
    teacher1 = FactoryGirl.create(:teacher, name: "Minerva McGonagall")
    teacher2 = FactoryGirl.create(:teacher, name: "Severus Snape")
    student = FactoryGirl.create(:student, name: "Harry Potter")
    FactoryGirl.create(:teacher_student_link, teacher: teacher1, student: student)
    FactoryGirl.create(:teacher_student_link, teacher: teacher2, student: student)
    
    expect(TeacherStudentLink.all.count).to eq(2)
    teacher1.destroy
    expect(TeacherStudentLink.all.count).to eq(1)
    student.destroy
    expect(TeacherStudentLink.all.count).to eq(0)
  end
  
  it "destroys course-student links when destroyed" do
    teacher = FactoryGirl.create(:teacher, name: "Minerva McGonagall")
    student = FactoryGirl.create(:student, name: "Harry Potter")
    course = FactoryGirl.create(:course, title: "Transfiguration", teacher: teacher)
    FactoryGirl.create(:course_students, course: course, student: student)
    
    expect(TeacherStudentLink.all.count).to eq(1) #CourseStudents creates this
    expect(CourseStudents.all.count).to eq(1)
    TeacherStudentLink.first.destroy
    expect(CourseStudents.all.count).to eq(0)
  end
end
