feature "user show page" do
  it "shows name" do
    user = FactoryGirl.build(:student, name: "Halle Berry")
    log_in_as(user)
    visit user_url(user)
    expect(page).to have_content "Halle Berry"
  end
  
  it "has a link to edit user info" do
    user = FactoryGirl.build(:student, name: "Halle Berry")
    log_in_as(user)
    visit user_url(user)
    click_link "Edit My Info"
    expect(page).to have_content "Edit My Info"
    expect(page).to have_field "Email"
  end
  
  context "teacher" do
    before(:each) do
      t1 = FactoryGirl.create(:teacher, name: "Prof")
      t2 = FactoryGirl.create(:teacher, name: "Prof2")
      s1 = FactoryGirl.create(:student, name: "Jodie")
      s2 = FactoryGirl.create(:student, name: "Janeese")
      c1 = FactoryGirl.create(:course, teacher: t1, title: "Course1")
      c2 = FactoryGirl.create(:course, teacher: t2, title: "Course2")
      FactoryGirl.create(:course_students, course: c1, student: s1)
      FactoryGirl.create(:teacher_student_link, teacher: t1, student: s2)
    end
    
    it "has a Students section" do
      t = User.find_by_name("Prof")
      log_in_already_created(t)
      visit user_url(t)
      
      expect(page).to have_content "Students"
    end
    
    it "shows teacher's courses (and no one else's)" do
      t = User.find_by_name("Prof")
      log_in_already_created(t)
      visit user_url(t)
      
      expect(page).to have_content "Course1"
      expect(page).to_not have_content "Course2"
    end
    
    it "has a delete button for each course" do
      t = User.find_by_name("Prof")
      log_in_already_created(t)
      visit user_url(t)
      
      expect(page).to have_button "Delete"
    end
    
    it "shows students in courses and not in courses" do
      t = User.find_by_name("Prof")
      log_in_already_created(t)
      visit user_url(t)
      
      expect(page).to have_content "Jodie"
      expect(page).to have_content "Janeese"
    end
    
    it "has appropriate message if there are no students" do
      t = User.find_by_name("Prof2")
      log_in_already_created(t)
      visit user_url(t)
      
      expect(page).to_not have_content "Jodie"
      expect(page).to have_content "You have no students."
    end
    
    it "has a form to add students" do
      t = User.find_by_name("Prof")
      log_in_already_created(t)
      visit user_url(t)
      
      expect(page).to have_content "Add a Student"
      expect(page).to have_field "Enter student email:"
      expect(page).to have_button "Add Student"
    end
    
    it "shows an error message if the email is incorrect for add student form" do
      t = User.find_by_name("Prof")
      log_in_already_created(t)
      visit user_url(t)
      fill_in "student_email", with: "gibberish"
      click_on "Add Student"
      
      expect(page).to have_content "Error. Email not found."
    end
    
    it "properly adds the student to the page" do
      t = User.find_by_name("Prof2")
      log_in_already_created(t)
      visit user_url(t)
      s = User.find_by_name("Jodie")
      fill_in "student_email", with: s.email
      click_on "Add Student"
      
      expect(page).to have_content "Jodie"
    end
  end
  
  context "student" do
    before(:each) do
      s = FactoryGirl.create(:student)
      t = FactoryGirl.create(:teacher)
      c1 = FactoryGirl.create(:course, title: "Course1", teacher: t)
      c2 = FactoryGirl.create(:course, title: "Course2", teacher: t)
      FactoryGirl.create(:course_students, student: s, course: c1)
      log_in_already_created(s)
      visit user_url(s)
    end
    
    it "lists all student's courses (and not others)" do
      expect(page).to have_content "Course1"
      expect(page).to_not have_content "Course2"
    end
    
    it "has a form to add a course" do
      expect(page).to have_field "Enter Course Code here:"
      expect(page).to have_button "Join Course"
    end
    
    it "has an error message if course doesn't exist for that course code" do
      fill_in "course_code", with: "gibberish"
      click_on "Join Course"
      
      expect(page).to have_content "Error. Course not found."
    end
    
    it "shows added courses in the student's course list" do
      c = Course.find_by_title("Course2")
      fill_in "course_code", with: c.course_code
      click_on "Join Course"
      
      expect(page).to have_content "Course2"
    end
  end
end

feature "user edit page" do
  before(:each) do
    user = FactoryGirl.build(:student, name: "Halle Berry")
    log_in_as(user)
    visit edit_user_url(user)
  end
  
  it "says 'Edit My Info'" do
    expect(page).to have_content "Edit My Info"
  end
  
  it "has correct fields" do
    expect(page).to have_field "Name"
    expect(page).to have_field "Email"
  end
  
  it "has a submit button" do
    expect(page).to have_button "Update"
  end
  
  it "allows correct input" do
    fill_in "Name", with: "Tom Cruise"
    click_button "Update"
    expect(page).to have_content "Tom Cruise"
  end
  
  it "shows errors for incorrect input" do
    fill_in "Name", with: ""
    click_button "Update"
    expect(page).to have_content "Name can't be blank"
  end
  
  it "has a way to cancel the update" do
    click_link "Cancel"
    expect(page).to_not have_field "Name"
  end
end