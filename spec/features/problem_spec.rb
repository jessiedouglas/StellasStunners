feature "problem index page" do
  before(:each) do
    FactoryGirl.create(:problem, title: "Problem1", is_original: true)
    FactoryGirl.create(:problem, title: "Problem2", is_original: true)
    FactoryGirl.create(:problem, title: "Problem3", is_original: false)
    log_in_as_teacher
    visit problems_url
  end
  
  it "has a heading" do
    expect(page).to have_content "All Problems"
  end
  
  it "links to all original problems" do
    expect(page).to have_link "Problem1"
    expect(page).to have_link "Problem2"
  end
  
  it "doesn't list unoriginal problems" do
    expect(page).to_not have_content "Problem 3"
  end
end

feature "problem show page" do
  context "basic" do
    before(:each) do
      problem = FactoryGirl.create(:problem, title: "TitleTitle", body: "This is the body", solution: "42")
      log_in_as_teacher
      visit problem_url(problem)
    end
    
    it "shows the problem's title, body, and description" do
      expect(page).to have_content "TitleTitle"
      expect(page).to have_content "This is the body"
      expect(page).to have_content "42"
    end
  
    it "shows the problem's stella number if it has one" do
      problem = Problem.find_by_title("TitleTitle")
      problem.update!(stella_number: 1000.12)
      visit problem_url(problem)
      
      expect(page).to have_content "1000.12"
    end
  end
  
  context "no current assignment" do
    it "doesn't give the option to add problem to an assignment" do
      problem = FactoryGirl.create(:problem, title: "Assignment1")
      log_in_as_teacher
      visit problem_url(problem)
      
      expect(page).to_not have_content "Add to Assignment1"
    end
  end
  
  context "there is a current assignment and the problem is not on it" do
    before(:each) do
      problem = FactoryGirl.create(:problem)
      teacher = FactoryGirl.build(:teacher)
      log_in_as(teacher)
      assignment = FactoryGirl.create(:assignment, teacher: teacher, title: "Assignment1")
      visit assignment_url(assignment)
      click_on "Set as Current Assignment"
      visit problem_url(problem)
    end
    
    it "gives the option to add the problem to the assignment" do
      expect(page).to have_button "Add to Assignment1"
    end
    
    it "shows a message after problem is added" do
      click_on "Add to Assignment1"
      expect(page).to_not have_content "Add to Assignment1"
      expect(page).to have_content "This problem has been added to Assignment1"
    end
  end
  
  context "there is a current assignment and the problem is on it" do
    it "tells the user that the problem is on the assignment" do
      problem = FactoryGirl.create(:problem)
      teacher = FactoryGirl.build(:teacher)
      log_in_as(teacher)
      assignment = FactoryGirl.create(:assignment, teacher: teacher, title: "Assignment1")
      FactoryGirl.create(:assignment_problem, assignment: assignment, problem: problem)
      visit assignment_url(assignment)
      click_on "Set as Current Assignment"
      visit problem_url(problem)
      
      expect(page).to_not have_content "Add to Assignment1"
      expect(page).to have_content "This problem has been added to Assignment1"
    end
  end
  
  context "logged in as the problem's creator" do
    before(:each) do
      teacher = FactoryGirl.build(:teacher)
      log_in_as(teacher)
      problem = FactoryGirl.create(:problem, creator: teacher, title: "TitleTitle")
      visit problem_url(problem)
    end
    
    it "has a link to edit the problem" do
      expect(page).to have_link "Edit"
    end
    
    it "has a link to delete the problem if the problem isn't in use by others" do
      expect(page).to have_button "Delete"
    end
    
    it "doesn't have a link to delete the problem if the problem is in use by others" do
      t = FactoryGirl.create(:teacher, name: "Snape")
      a = FactoryGirl.create(:assignment, teacher: t)
      p = Problem.find_by_title("TitleTitle")
      FactoryGirl.create(:assignment_problem, assignment: a, problem: p)
      visit problem_url(p)
      
      expect(page).to have_link "Edit"
      expect(page).to_not have_button "Delete"
    end
  end
  
  context "logged in otherwise" do
    it "doesn't have options to edit or delete" do
      teacher1 = FactoryGirl.build(:teacher, name: "Snape")
      teacher2 = FactoryGirl.create(:teacher, name: "McGonagall")
      log_in_as(teacher1)
      problem = FactoryGirl.create(:problem, creator: teacher2, title: "TitleTitle")
      visit problem_url(problem)
      
      expect(page).to_not have_link "Edit"
      expect(page).to_not have_button "Delete"
    end
  end
end

feature "new/edit problem forms" do
  shared_examples_for "shared form" do
    it "has fields for title, body, and solution" do
      expect(page).to have_field "Title"
      expect(page).to have_field "Body"
      expect(page).to have_field "Solution"
    end
    
    it "doesn't have a field for stella number" do
      expect(page).to_not have_field "Stella Number"
    end
  end
  
  context "new form" do
    before(:each) do
      log_in_as_teacher
      visit new_problem_url
    end
    
    it "has a title" do
      expect(page).to have_content "Add a New Problem"
    end
    
    it "has a create button" do
      expect(page).to have_button "Create Problem"
    end
    
    it_behaves_like "shared form"
  end
  
  context "edit form" do
    before(:each) do
      teacher = FactoryGirl.build(:teacher)
      log_in_as(teacher)
      problem = FactoryGirl.create(:problem, creator: teacher)
      visit edit_problem_url(problem)
    end
    
    it "has a title" do
      expect(page).to have_content "Edit Problem"
    end
    
    it "has a save button" do
      expect(page).to have_button "Save"
    end
    
    it_behaves_like "shared form"
  end
  
  context "user is an admin" do
    it "has a field for stella number" do
      admin = FactoryGirl.build(:admin)
      log_in_as(admin)
      visit new_problem_url
      
      expect(page).to have_field "Stella Number"
    end
  end
end