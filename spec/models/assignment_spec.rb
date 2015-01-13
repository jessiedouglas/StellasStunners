require 'spec_helper'

describe Assignment do
  it "allows a simple assignment to be created" do
    a = FactoryGirl.build(:assignment)
    expect(a).to be_valid
  end
  
  it "allows a due date and description" do
    teacher = FactoryGirl.build(:teacher)
    a1 = FactoryGirl.build(:assignment, teacher: teacher, description: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
    a2 = FactoryGirl.build(:assignment, teacher: teacher, due_date: Date.today)
    expect(a1).to be_valid
    expect(a2).to be_valid
  end
  
  it "requires a title" do
    a = FactoryGirl.build(:assignment, title: "")
    expect(a).to_not be_valid
  end
  
  context "associations" do
    before(:each) do
      teacher = FactoryGirl.create(:teacher, name: 'Snape')
      FactoryGirl.create(:assignment, teacher: teacher, title: "TitleTitle")
    end
    
    it "properly links with teacher" do
      teacher = User.find_by_name("Snape")
      a = Assignment.find_by_title("TitleTitle")
      expect(teacher.created_assignments.first).to eq(a)
      expect(a.teacher).to eq(teacher)
    end
    
    it "destroys itself when the teacher is destroyed" do
      expect(Assignment.count).to eq(1)
      User.find_by_name("Snape").destroy
      expect(Assignment.count).to eq(0)
    end
    
    it "properly links with students" do
      a = Assignment.find_by_title("TitleTitle")
      s1 = FactoryGirl.create(:student, name: "HarryPotter")
      s2 = FactoryGirl.create(:student, name: "RonWeasley")
      FactoryGirl.create(:student_assignment_link, assignment: a, student: s1)
      
      expect(a.students).to eq([s1])
    end
  end
end
