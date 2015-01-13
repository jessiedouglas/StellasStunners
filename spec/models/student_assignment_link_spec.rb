require 'spec_helper'

describe StudentAssignmentLink do
  it "allows a standard student-assignment link" do
    link = FactoryGirl.build(:student_assignment_link)
    expect(link).to be_valid
  end
  
  context "associations" do
    it "properly links to students and assignments" do
      student = FactoryGirl.create(:student, name: "HarryPotter")
      assignment = FactoryGirl.create(:assignment, title: "TitleTitle")
      link = FactoryGirl.create(:student_assignment_link, student: student, assignment: assignment)
      
      expect(link.student).to eq(student)
      expect(link.assignment).to eq (assignment)
    end
  
    it "destroys itself when student is destroyed" do
      student = FactoryGirl.create(:student, name: "HarryPotter")
      assignment = FactoryGirl.create(:assignment, title: "TitleTitle")
      FactoryGirl.create(:student_assignment_link, student: student, assignment: assignment)
      
      expect(StudentAssignmentLink.count).to eq(1)
      student.destroy
      expect(StudentAssignmentLink.count).to eq(0)
    end
  
    it "destroys itself when assignment is destroyed" do
      student = FactoryGirl.create(:student, name: "HarryPotter")
      assignment = FactoryGirl.create(:assignment, title: "TitleTitle")
      FactoryGirl.create(:student_assignment_link, student: student, assignment: assignment)
      
      expect(StudentAssignmentLink.count).to eq(1)
      assignment.destroy
      expect(StudentAssignmentLink.count).to eq(0)
    end
  end
end
