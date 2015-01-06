require 'spec_helper'

describe Course do
  it "allows a standard course" do
    course = FactoryGirl.build(:course)
    expect(course).to be_valid
  end
  
  it "allows a course with description" do
    course = FactoryGirl.build(:course, description: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
    expect(course).to be_valid
  end
  
  it "requires necessary fields" do
    course = FactoryGirl.build(:course, title: "")
    expect(course).to_not be_valid
  end
  
  it "doesn't allow duplicates for a single teacher" do
    teacher = FactoryGirl.create(:teacher)
    FactoryGirl.create(:course, title: "Title", teacher: teacher)
    course = FactoryGirl.build(:course, title: "Title", teacher: teacher)
    expect(course).to_not be_valid
  end
  
  it "allows duplicates otherwise" do
    teacher1 = FactoryGirl.create(:teacher, username: "Timon")
    teacher2 = FactoryGirl.create(:teacher, username: "Pumbaa")
    FactoryGirl.create(:course, title: "Title", teacher: teacher1)
    
    course1 = FactoryGirl.build(:course, title: "Title", teacher: teacher2)
    course2 = FactoryGirl.build(:course, title: "Other", teacher: teacher1)
    
    expect(course1).to be_valid
    expect(course2).to be_valid
  end
  
  it "properly links with a teacher" do
    t = FactoryGirl.create(:teacher, username: "Simba")
    course = FactoryGirl.create(:course, teacher: t)
    
    expect(course.teacher).to eq(t)
    expect(t.taught_courses.first).to eq(course)
  end
  
  it "destroys itself when the teacher is destroyed" do
    t = FactoryGirl.create(:teacher, username: "Simba")
    FactoryGirl.create(:course, teacher: t)
    
    expect(Course.all.count).to eq(1)
    t.destroy
    expect(Course.all).to be_empty
  end
end
