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
  
  it "doesn't allow for fields to be blank" do
    a = FactoryGirl.build(:student, username: "")
    b = FactoryGirl.build(:teacher, email: "")
    c = FactoryGirl.build(:admin, user_type: "")
    
    [a, b, c].each do |user|
      expect(user).to_not be_valid
    end
  end
  
  it "doesn't allow duplication of usernames or emails" do
    a = FactoryGirl.create(:student, username: "Bob")
    b = FactoryGirl.build(:teacher, username: "Bob", email: "a@b.c")
    c = FactoryGirl.create(:admin, email: "d@e.f")
    d = FactoryGirl.build(:student, username: "Joe", email: "d@e.f")
    
    expect(b).to_not be_valid
    expect(d).to_not be_valid
  end
  
  it "doesn't allow a password with fewer than 8 characters" do
    a = FactoryGirl.build(:student, password: "hi")
    expect(a).to_not be_valid
  end
  
  context "searching for users" do
    it "allows a user to be found using email or username and password" do
      FactoryGirl.create(:student, username: "Student", password: "password")
      FactoryGirl.create(:teacher, email: "teacher@t.com", password: "abcdefgh")
      
      a = User.find_by_credentials("Student", "password")
      b = User.find_by_credentials("teacher@t.com", "abcdefgh")
      
      expect(a).to_not be_nil
      expect(b).to_not be_nil
    end
    
    it "doesn't find non-existant users" do
      a = User.find_by_credentials("hello", "worldddd")
      expect(a).to be_nil
    end
    
    it "doesn't find users if incorrect username or password is provided" do
      FactoryGirl.create(:student, username: "Student", password: "password")
      a = User.find_by_credentials("Student", "abcdefgh")
      b = User.find_by_credentials("abcd", "password")
      
      expect(a).to be_nil
      expect(b).to be_nil
    end
  end
  
  it "resets the session token" do
    user = FactoryGirl.create(:student)
    token = user.session_token
    
    user.reset_session_token!
    
    expect(token).to_not eq(user.session_token)
  end
  
  context "associations" do
    before(:each) do
      teacher1 = FactoryGirl.create(:teacher, username: "Minerva McGonagall")
      teacher2 = FactoryGirl.create(:teacher, username: "Severus Snape")
      student1 = FactoryGirl.create(:student, username: "Harry Potter")
      student2 = FactoryGirl.create(:student, username: "Draco Malfoy")
      FactoryGirl.create(:teacher_student_link, teacher: teacher1, student: student1)
      FactoryGirl.create(:teacher_student_link, teacher: teacher1, student: student2)
      FactoryGirl.create(:teacher_student_link, teacher: teacher2, student: student1)
    end
    
    it "properly links to the correct TeacherStudentLinks" do
      teacher1 = User.find_by_username("Minerva McGonagall")
      teacher2 = User.find_by_username("Severus Snape")
      student1 = User.find_by_username("Harry Potter")
      student2 = User.find_by_username("Draco Malfoy")
      
      expect(teacher1.links_with_students.count).to eq(2)
      expect(teacher2.links_with_students.count).to eq(1)
      expect(student1.links_with_teachers.count).to eq(2)
      expect(student2.links_with_teachers.count).to eq(1)
      expect(teacher1.links_with_teachers.count).to eq(0)
      expect(student1.links_with_students.count).to eq(0)
    end
    
    it "properly links to teachers and students" do
      teacher1 = User.find_by_username("Minerva McGonagall")
      teacher2 = User.find_by_username("Severus Snape")
      student1 = User.find_by_username("Harry Potter")
      student2 = User.find_by_username("Draco Malfoy")
      
      expect(teacher1.students).to eq([student1, student2])
      expect(teacher2.students).to eq([student1])
      expect(student1.teachers).to eq([teacher1, teacher2])
      expect(student2.teachers).to eq([teacher1])
      expect(teacher2.teachers).to be_empty
      expect(student2.students).to be_empty
    end
  end
end
