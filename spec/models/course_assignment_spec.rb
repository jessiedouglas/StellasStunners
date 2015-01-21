require 'spec_helper'

describe CourseAssignment do
  it "allows a basic course-assignment link" do
    t = FactoryGirl.create(:teacher)
    c = FactoryGirl.create(:course, teacher: t)
    a = FactoryGirl.create(:assignment, teacher: t)
    
    link = FactoryGirl.build(:course_assignment, assignment: a, course: c)
    expect(link).to be_valid
  end
  
  it "doesn't allow course-assignment duplications" do
    t = FactoryGirl.create(:teacher)
    c = FactoryGirl.create(:course, teacher: t)
    a = FactoryGirl.create(:assignment, teacher: t)
    FactoryGirl.create(:course_assignment, assignment: a, course: c)
    
    link = FactoryGirl.build(:course_assignment, assignment: a, course: c)
    expect(link).to_not be_valid
  end
  
  it "allows other duplications" do
    t = FactoryGirl.create(:teacher)
    c1 = FactoryGirl.create(:course, teacher: t, title: "Course1")
    c2 = FactoryGirl.create(:course, teacher: t, title: "Course2")
    a1 = FactoryGirl.create(:assignment, teacher: t)
    a2 = FactoryGirl.create(:assignment, teacher: t)
    FactoryGirl.create(:course_assignment, assignment: a1, course: c1)
    
    link1 = FactoryGirl.build(:course_assignment, assignment: a1, course: c2)
    link2 = FactoryGirl.build(:course_assignment, assignment: a2, course: c1)
    expect(link1).to be_valid
    expect(link2).to be_valid
  end
  
  context "associations" do
    it "properly links to courses and assignments" do
      t = FactoryGirl.create(:teacher)
      c = FactoryGirl.create(:course, teacher: t)
      a = FactoryGirl.create(:assignment, teacher: t)
      link = FactoryGirl.create(:course_assignment, course: c, assignment: a)
      
      expect(link.course).to eq(c)
      expect(link.assignment).to eq(a)
    end
    
    it "creates student-assignment links" do
      t = FactoryGirl.create(:teacher)
      c = FactoryGirl.create(:course, teacher: t)
      a = FactoryGirl.create(:assignment, teacher: t)
      s1 = FactoryGirl.create(:student, name: "Harry")
      s2 = FactoryGirl.create(:student, name: "Hermione")
      s3 = FactoryGirl.create(:student, name: "Ron")
      FactoryGirl.create(:course_students, course: c, student: s1)
      FactoryGirl.create(:course_students, course: c, student: s2)
    
      expect(StudentAssignmentLink.count).to eq(0)
      FactoryGirl.create(:course_assignment, course: c, assignment: a)
      expect(StudentAssignmentLink.count).to eq(2)
    end
    
    it "deletes student-assignment links when deleted" do
      t = FactoryGirl.create(:teacher)
      c = FactoryGirl.create(:course, teacher: t)
      a = FactoryGirl.create(:assignment, teacher: t)
      s1 = FactoryGirl.create(:student, name: "Harry")
      s2 = FactoryGirl.create(:student, name: "Hermione")
      FactoryGirl.create(:course_students, course: c, student: s1)
      FactoryGirl.create(:course_students, course: c, student: s2)
      link = FactoryGirl.create(:course_assignment, course: c, assignment: a)
      
      expect(StudentAssignmentLink.count).to eq(2)
      CourseAssignment.destroy(link.id)
      expect(StudentAssignmentLink.count).to eq(0)
    end
    
    it "doesn't allow course and assignment with different teachers" do
      t1 = FactoryGirl.create(:teacher, name: "Trelawney")
      t2 = FactoryGirl.create(:teacher, name: "Moody")
      c = FactoryGirl.create(:course, teacher: t1)
      a = FactoryGirl.create(:assignment, teacher: t2)
      
      link = FactoryGirl.build(:course_assignment, course: c, assignment: a)
      expect(link).to_not be_valid
    end
  end
end
