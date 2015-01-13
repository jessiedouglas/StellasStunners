require 'spec_helper'

describe AssignmentProblem do
  it "allows a standard link to be created" do
    link = FactoryGirl.build(:assignment_problem)
    expect(link).to be_valid
  end
  
  it "doesn't allow the same problem on the same assignment more than once" do
    p = FactoryGirl.create(:problem)
    a = FactoryGirl.create(:assignment)
    FactoryGirl.create(:assignment_problem, assignment: a, problem: p)
    link = FactoryGirl.build(:assignment_problem, assignment: a, problem: p)
    
    expect(link).to_not be_valid
  end
  
  it "allows duplication otherwise" do
    p1 = FactoryGirl.create(:problem)
    p2 = FactoryGirl.create(:problem)
    t = FactoryGirl.create(:teacher)
    a1 = FactoryGirl.create(:assignment, teacher: t)
    a2 = FactoryGirl.create(:assignment, teacher: t)
    FactoryGirl.create(:assignment_problem, assignment: a1, problem: p1)
    link1 = FactoryGirl.build(:assignment_problem, assignment: a2, problem: p1)
    link2 = FactoryGirl.build(:assignment_problem, assignment: a1, problem: p2)
    
    expect(link1).to be_valid
    expect(link2).to be_valid
  end
  
  context "associations" do
    it "properly connects with assignments and problems" do
      t = FactoryGirl.create(:teacher)
      a1 = FactoryGirl.create(:assignment, teacher: t)
      p1 = FactoryGirl.create(:problem, title: "Title1")
      a2 = FactoryGirl.create(:assignment, teacher: t)
      p2 = FactoryGirl.create(:problem, title: "Title2")
      link = FactoryGirl.create(:assignment_problem, assignment: a1, problem: p1)
      
      expect(link.assignment).to eq(a1)
      expect(link.problem).to eq(p1)
      expect(p1.assignments).to eq([a1])
      expect(a1.problems).to eq([p1])
    end
    
    it "destroys itself when the assignment is destroyed" do
      a = FactoryGirl.create(:assignment)
      p = FactoryGirl.create(:problem)
      FactoryGirl.create(:assignment_problem, assignment: a, problem: p)
      
      expect(AssignmentProblem.count).to eq(1)
      a.destroy
      expect(AssignmentProblem.count).to eq(0)
    end
    
    it "destroys itself when the problem is destroyed" do
      a = FactoryGirl.create(:assignment)
      p = FactoryGirl.create(:problem)
      FactoryGirl.create(:assignment_problem, assignment: a, problem: p)
      
      expect(AssignmentProblem.count).to eq(1)
      p.destroy
      expect(AssignmentProblem.count).to eq(0)
    end
  end
end
