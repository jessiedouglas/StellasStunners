feature "new/edit assignment forms" do
  shared_examples_for "shared form" do
    it "has the proper fields" do
      expect(page).to have_field "Title"
      expect(page).to have_field "Description"
      expect(page).to have_field "Due Date"
    end
  end
  
  context "new assignment form" do
    before(:each) do
      log_in_as_teacher
      visit new_assignment_url
    end
    
    it "has a create button" do
      expect(page).to have_button "Create Assignment"
    end
    
    it "has a title" do
      expect(page).to have_content "New Assignment"
    end
    
    it "changes the current assignment" do
      fill_in "Title", with: "ThisIsTheTitle"
      click_on "Create Assignment"
      visit new_assignment_url
      expect(page).to have_content "Current Assignment: ThisIsTheTitle"
    end
    
    it "has a link to browse problems" do
      expect(page).to have_link "Browse problems"
    end
    
    it_behaves_like "shared form"
  end
  
  context "edit assignment form" do
    before(:each) do
      teacher = FactoryGirl.build(:teacher, name: "McGonagall")
      log_in_as(teacher)
      a = FactoryGirl.create(:assignment, teacher: teacher)
      visit edit_assignment_url(a)
    end
    
    it "has a save button" do
      expect(page).to have_button "Save"
    end
    
    it "has a title" do
      expect(page).to have_content "Edit Assignment"
    end
    
    it_behaves_like "shared form"
  end
end

feature "assignment index page" do
  before(:each) do
    teacher = FactoryGirl.build(:teacher, name: "Flitwick")
    log_in_as(teacher)
    FactoryGirl.create(:assignment, teacher: teacher, title: "Real1")
    FactoryGirl.create(:assignment, teacher: teacher, title: "Real2")
    FactoryGirl.create(:assignment, title: "NotReal")
    visit assignments_url
  end
  
  it "lists all teacher's assignments" do
    expect(page).to have_content "Real1"
    expect(page).to have_content "Real2"
  end
  
  it "doesn't list other teachers' assignments" do
    expect(page).to_not have_content "NotReal"
  end
  
  it "has edit buttons for assignments" do
    expect(page).to have_link "Edit"
  end
  
  it "has a link to create a new assignment" do
    expect(page).to have_content "Create a New Assignment"
  end
end

feature "assignment show page" do
  before(:each) do
    teacher = FactoryGirl.build(:teacher, name: "Lupin")
    log_in_as(teacher)
    a = FactoryGirl.create(:assignment, title: "TitleTitle", description: "BibbityBoppityBoo", teacher: teacher)
    p1 = FactoryGirl.create(:problem, title: "Problem1", body: "bodybodybody")
    p2 = FactoryGirl.create(:problem, title: "Problem2", body: "bodybodybody")
    FactoryGirl.create(:assignment_problem, problem: p1, assignment: a)
    FactoryGirl.create(:assignment_problem, problem: p2, assignment: a)
    visit assignment_url(a)
  end
  
  it "has the assignment title, description, and due date" do
    expect(page).to have_content "TitleTitle"
    expect(page).to have_content "BibbityBoppityBoo"
  end
  
  it "lists all the problems" do
    expect(page).to have_content "Problem1"
    expect(page).to have_content "Problem2"
    expect(page).to have_content "bodybodybody"
  end
  
  context "teacher logged in" do
    it "has a link to the problem show page" do
      expect(page).to have_link "Problem1"
      expect(page).to have_link "Problem2"
    end
    
    it "has a link to browse more problems" do
      expect(page).to have_link "Browse problems"
    end
    
    it "has assign to student and course forms" do
      expect(page).to have_content "Assign this Problem Set"
    end
    
    it "has a link to edit the assignment" do
      expect(page).to have_link "Edit Assignment"
    end
  end
  
  context "student logged in" do
    before(:each) do
      click_on "Log Out"
      s = FactoryGirl.build(:student)
      log_in_as(s)
      a = Assignment.find_by_title("TitleTitle")
      FactoryGirl.create(:student_assignment_link, student: s, assignment: a)
      visit assignment_url(a)
    end
    
    it "does not have a link to the problem show page" do
      expect(page).to_not have_link "Problem1"
      expect(page).to_not have_link "Problem2"
    end
    
    it "doesn't have assign to student or course forms" do
      expect(page).to_not have_content "Assign this Problem Set"
    end
  end
  
  context "assign to student form" do
    it "has a label" do
      expect(page).to have_content "to a Student"
    end
    
    it "has a submit button" do
      expect(page).to have_button "Assign to Student"
    end
  end
  
  context "assign to course form" do
    it "has a label" do
      expect(page).to have_content "to a Course"
    end
    
    it "has a submit button" do
      expect(page).to have_button "Assign to Course"
    end
  end
end