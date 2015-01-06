require 'spec_helper'

describe CourseStudents do
  it "allows a standard course-student link" do
    link = FactoryGirl.build(:course_students)
    expect(link).to be_valid
  end
  
  it "doesn't allow course-student duplicates" do
    course = FactoryGirl.create(:course, title: "Basket Weaving")
    student = FactoryGirl.create(:student, username: "Hamlet")
    FactoryGirl.create(:course_students, course: course, student: student)
    
    link = FactoryGirl.build(:course_students, course: course, student: student)
    expect(link).to_not be_valid
  end
  
  it "allows individual duplicates" do
    teacher = FactoryGirl.create(:teacher, username: "MOM")
    course1 = FactoryGirl.create(:course, title: "Basket Weaving")
    course2 = FactoryGirl.create(:course, title: "Basket Crocheting", teacher: teacher)
    student1 = FactoryGirl.create(:student, username: "Hamlet")
    student2 = FactoryGirl.create(:student, username: "Othello")
    FactoryGirl.create(:course_students, course: course1, student: student1)
    
    link1 = FactoryGirl.build(:course_students, course: course1, student: student2)
    link2 = FactoryGirl.build(:course_students, course: course2, student: student1)
    expect(link1).to be_valid
    expect(link2).to be_valid
  end
  
  it "properly links with courses and students" do
    course = FactoryGirl.create(:course, title: "Basket Weaving")
    student = FactoryGirl.create(:student, username: "Hamlet")
    link = FactoryGirl.create(:course_students, course: course, student: student)
    expect(link.course).to eq(course)
    expect(link.student).to eq(student)
  end
  
  it "destroys itself if course or student is destroyed" do
    course = FactoryGirl.create(:course, title: "Basket Crocheting")
    student1 = FactoryGirl.create(:student, username: "Hamlet")
    student2 = FactoryGirl.create(:student, username: "Othello")
    FactoryGirl.create(:course_students, course: course, student: student1)
    FactoryGirl.create(:course_students, course: course, student: student2)
    
    expect(CourseStudents.all.count).to eq(2)
    student1.destroy
    expect(CourseStudents.all.count).to eq(1)
    course.destroy
    expect(CourseStudents.all.count).to eq(0)
  end
  
  it "creates a student-teacher link if none exists" do
    teacher = FactoryGirl.create(:teacher, username: "MOM")
    course = FactoryGirl.create(:course, title: "Basket Weaving", teacher: teacher)
    student = FactoryGirl.create(:student, username: "Hamlet")
    FactoryGirl.create(:course_students, course: course, student: student)
    
    expect(TeacherStudentLink.all.count).to eq(1)
    expect(teacher.students).to eq([student])
  end
end
