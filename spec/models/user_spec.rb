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
end
