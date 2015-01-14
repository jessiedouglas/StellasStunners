require 'spec_helper'

describe Problem do
  it "allows a standard problem" do
    problem = FactoryGirl.build(:problem)
    expect(problem).to be_valid
  end
  
  it "requires all necessary fields" do
    p1 = FactoryGirl.build(:problem, title: "")
    p2 = FactoryGirl.build(:problem, body: "")
    p3 = FactoryGirl.build(:problem, solution: "")
    
    [p1, p2, p3].each do |problem|
      expect(problem).to_not be_valid
    end
  end
  
  it "allows a stella number and is_original to be false" do
    p1 = FactoryGirl.build(:problem, stella_number: 4000.12)
    p2 = FactoryGirl.build(:problem, is_original: false)
    
    expect(p1).to be_valid
    expect(p2).to be_valid
  end
  
  context "in_use?" do
    before(:each) do
      teacher = FactoryGirl.create(:teacher, name: "hello")
      # login(teacher)
      assignment = FactoryGirl.create(:assignment, teacher: teacher)
      problem = FactoryGirl.create(:problem, title: "TitleTitle")
      FactoryGirl.create(:assignment_problem, assignment: assignment, problem: problem)
    end
    
    it "returns true if other users are using the problem" do
      problem = Problem.find_by_title("TitleTitle")
      t = FactoryGirl.create(:teacher, name: "world")
      a = FactoryGirl.create(:assignment, teacher: t)
      FactoryGirl.create(:assignment_problem, assignment: a, problem: problem)
      
      expect(problem).to be_in_use
    end
    
    it "returns false if it is only being used in one assignment" do
      problem = Problem.find_by_title("TitleTitle")
      
      expect(problem).to_not be_in_use
    end
    
    it "returns false if all uses are in one teacher's assignments" do
      t = User.find_by_name("hello")
      problem = Problem.find_by_title("TitleTitle")
      a1 = FactoryGirl.create(:assignment, teacher: t)
      a2 = FactoryGirl.create(:assignment, teacher: t)
      FactoryGirl.create(:assignment_problem, assignment: a1, problem: problem)
      FactoryGirl.create(:assignment_problem, assignment: a2, problem: problem)
      
      expect(problem).to_not be_in_use
    end
  end
end
