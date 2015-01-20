require 'spec_helper'

describe User do
  it "allows each type of user to be created" do 
    student = FactoryGirl.build(:student)
    teacher = FactoryGirl.build(:teacher)
    admin = FactoryGirl.build(:admin)
    
    [student, teacher, admin].each do |user|
      expect(user).to be_valid
    end
  end
  
  it "doesn't allow a different type of user to be created" do
    a = FactoryGirl.build(:student, user_type: "BLAH")
    expect(a).to_not be_valid
  end
  
  it "doesn't allow for name, email, or user_type fields to be blank" do
    a = FactoryGirl.build(:student, name: "")
    b = FactoryGirl.build(:teacher, email: "")
    c = FactoryGirl.build(:admin, user_type: "")
    
    [a, b, c].each do |user|
      expect(user).to_not be_valid
    end
  end
  
  it "doesn't allow duplication of emails" do
    c = FactoryGirl.create(:admin, email: "d@e.f")
    d = FactoryGirl.build(:student, name: "Joe", email: "d@e.f")
    
    expect(d).to_not be_valid
  end
  
  it "doesn't allow a password with fewer than 8 characters" do
    a = FactoryGirl.build(:student, password: "hi")
    expect(a).to_not be_valid
  end
  
  context "searching for users" do
    it "allows a user to be found using email and password" do
      FactoryGirl.create(:teacher, email: "teacher@t.com", password: "abcdefgh")
      b = User.find_by_credentials("teacher@t.com", "abcdefgh")
      
      expect(b).to_not be_nil
    end
    
    it "doesn't find non-existant users" do
      a = User.find_by_credentials("hello", "worldddd")
      expect(a).to be_nil
    end
    
    it "doesn't find users if incorrect email or password is provided" do
      FactoryGirl.create(:student, email: "Student", password: "password")
      a = User.find_by_credentials("Student", "abcdefgh")
      b = User.find_by_credentials("abcd", "password")
      
      expect(a).to be_nil
      expect(b).to be_nil
    end
  end
  
  context "teacher-student associations" do
    before(:each) do
      teacher1 = FactoryGirl.create(:teacher, name: "Minerva McGonagall")
      teacher2 = FactoryGirl.create(:teacher, name: "Severus Snape")
      student1 = FactoryGirl.create(:student, name: "Harry Potter")
      student2 = FactoryGirl.create(:student, name: "Draco Malfoy")
      FactoryGirl.create(:teacher_student_link, teacher: teacher1, student: student1)
      FactoryGirl.create(:teacher_student_link, teacher: teacher1, student: student2)
      FactoryGirl.create(:teacher_student_link, teacher: teacher2, student: student1)
    end
    
    it "properly links to the correct TeacherStudentLinks" do
      teacher1 = User.find_by_name("Minerva McGonagall")
      teacher2 = User.find_by_name("Severus Snape")
      student1 = User.find_by_name("Harry Potter")
      student2 = User.find_by_name("Draco Malfoy")
      
      expect(teacher1.links_with_students.count).to eq(2)
      expect(teacher2.links_with_students.count).to eq(1)
      expect(student1.links_with_teachers.count).to eq(2)
      expect(student2.links_with_teachers.count).to eq(1)
      expect(teacher1.links_with_teachers.count).to eq(0)
      expect(student1.links_with_students.count).to eq(0)
    end
    
    it "properly links to teachers and students" do
      teacher1 = User.find_by_name("Minerva McGonagall")
      teacher2 = User.find_by_name("Severus Snape")
      student1 = User.find_by_name("Harry Potter")
      student2 = User.find_by_name("Draco Malfoy")
      
      expect(teacher1.students).to match_array([student1, student2])
      expect(teacher2.students).to eq([student1])
      expect(student1.teachers).to match_array([teacher1, teacher2])
      expect(student2.teachers).to eq([teacher1])
      expect(teacher2.teachers).to be_empty
      expect(student2.students).to be_empty
    end
  end
  
  context "student-course associations" do
    before(:each) do
      teacher = FactoryGirl.create(:teacher, name: "Marlon Brando")
      course1 = FactoryGirl.create(:course, title: "Foo", teacher: teacher)
      course2 = FactoryGirl.create(:course, title: "Bar", teacher: teacher)
      student1 = FactoryGirl.create(:student, name: "Greta Garbo")
      student2 = FactoryGirl.create(:student, name: "Winnie the Pooh")
      FactoryGirl.create(:course_students, course: course1, student: student1)
      FactoryGirl.create(:course_students, course: course1, student: student2)
      FactoryGirl.create(:course_students, course: course2, student: student1)
    end
    
    it "properly links to the correct CourseStudents" do
      course1 = Course.find_by_title("Foo")
      course2 = Course.find_by_title("Bar")
      student1 = User.find_by_name("Greta Garbo")
      student2 = User.find_by_name("Winnie the Pooh")
      
      expect(course1.links_with_students.count).to eq(2)
      expect(course2.links_with_students.count).to eq(1)
      expect(student1.links_with_taken_courses.count).to eq(2)
      expect(student2.links_with_taken_courses.count).to eq(1)
    end
    
    it "properly links students to courses" do
      course1 = Course.find_by_title("Foo")
      course2 = Course.find_by_title("Bar")
      student1 = User.find_by_name("Greta Garbo")
      student2 = User.find_by_name("Winnie the Pooh")
      
      expect(course1.students).to match_array([student1, student2])
      expect(course2.students).to eq([student1])
      expect(student1.taken_courses).to match_array([course1, course2])
      expect(student2.taken_courses).to eq([course1])
    end
  end
end
