feature "new Course form" do
  before(:each) do
    teacher = FactoryGirl.build(:teacher)
    log_in_as(teacher)
    visit user_url(teacher)
  end
  
  it "has a label" do
    expect(page).to have_content "Add a New Course"
  end
  
  it "has the proper fields" do
    expect(page).to have_field "Title"
    expect(page).to have_field "Description"
  end
  
  it "has a submit button" do
    expect(page).to have_button "Create Course"
  end
  
  it "stays on the same page, with an error message, if there is a problem" do
    click_on "Create Course"
    expect(page).to have_content "Create Course"
    expect(page).to have_content "Title can't be blank"
  end
  
  it "redirects to course show page on success" do
    fill_in "course[title]", with: "TitleTitle"
    click_on "Create Course"
    expect(page).to have_content "TitleTitle"
    expect(page).to_not have_content "Create Course"
  end
end

feature "Course show page" do
  before(:each) do
    teacher = FactoryGirl.create(:teacher, name: "Sally")
    course = FactoryGirl.create(:course, title: "TitleTitle", description: "This is very descriptive", teacher: teacher)
    s1 = FactoryGirl.create(:student, name: "Prince")
    s2 = FactoryGirl.create(:student, name: "Cher")
    FactoryGirl.create(:course_students, course: course, student: s1)
    FactoryGirl.create(:course_students, course: course, student: s2)
  end
  
  it "has the course title and description" do
    teacher = User.find_by_name("Sally")
    log_in_already_created(teacher)
    course = Course.find_by_title("TitleTitle")
    visit course_url(course)
    
    expect(page).to have_content "TitleTitle"
    expect(page).to have_content "This is very descriptive"
  end
  
  it "lists all assignments" do
    teacher = User.find_by_name("Sally")
    log_in_already_created(teacher)
    course = Course.find_by_title("TitleTitle")
    a1 = FactoryGirl.create(:assignment, title: "Assignment1", teacher: teacher)
    a2 = FactoryGirl.create(:assignment, title: "Assignment2", teacher: teacher)
    a3 = FactoryGirl.create(:assignment, title: "Assignment3", teacher: teacher)
    FactoryGirl.create(:course_assignment, course: course, assignment: a1)
    FactoryGirl.create(:course_assignment, course: course, assignment: a2)
    visit course_url(course)
    
    expect(page).to have_content "Assignment1"
    expect(page).to have_content "Assignment2"
    expect(page).to_not have_content "Assignment3"
  end
  
  context "teacher user" do
    before(:each) do
      teacher = User.find_by_name("Sally")
      log_in_already_created(teacher)
      course = Course.find_by_title("TitleTitle")
      visit course_url(course)
    end
    
    it "shows the course code" do
      course = Course.find_by_title("TitleTitle")
      
      expect(page).to have_content "Course Code:"
      expect(page).to have_content course.course_code
    end
    
    it "shows the students in the class" do
      expect(page).to have_content "Students"
      expect(page).to have_content "Prince"
      expect(page).to have_content "Cher"
    end
    
    it "has an edit and a delete button" do
      expect(page).to have_link "Edit"
      expect(page).to have_button "Delete"
    end
  end
  
  context "student user" do
    before(:each) do
      student = User.find_by_name("Prince")
      log_in_already_created(student)
      course = Course.find_by_title("TitleTitle")
      visit course_url(course)
    end
    
    it "doesn't show course code or other students" do
      course = Course.find_by_title("TitleTitle")
      
      expect(page).to_not have_content "Course Code:"
      expect(page).to_not have_content course.course_code
      expect(page).to_not have_content "Students"
      expect(page).to_not have_content "Cher"
    end
    
    it "doesn't show add student form" do
      expect(page).to_not have_content "Add Student"
    end
  end
  
  context "add student form" do
    before(:each) do
      teacher = User.find_by_name("Sally")
      log_in_already_created(teacher)
      student = FactoryGirl.create(:student, name: "Madonna")
      FactoryGirl.create(:teacher_student_link, teacher: teacher, student: student)
      course = Course.find_by_title("TitleTitle")
      visit course_url(course)
    end
    
    it "has a heading" do
      expect(page).to have_content "Add Student"
    end
    
    it "has a submit button" do
      expect(page).to have_button "Add"
    end
    
    it "displays an error message when a student is not selected" do
      click_button "Add"
      
      expect(page).to have_content "Student can't be blank"
    end
    
    it "adds student to the student list when properly submitted" do
      select "Madonna"
      click_button "Add"
      
      expect(page).to have_content "Madonna"
    end
  end
end

feature "Course edit page" do
  before(:each) do
    teacher = FactoryGirl.build(:teacher)
    log_in_as(teacher)
    course = FactoryGirl.create(:course, teacher: teacher)
    visit edit_course_url(course)
  end
  
  it "states that it is the edit page" do
    expect(page).to have_content "Edit Course"
  end
  
  it "has correct fields" do
    expect(page).to have_field "Title"
    expect(page).to have_field "Description"
  end
  
  it "has a save button" do
    expect(page).to have_button "Save"
  end
  
  it "shows error messages with errors" do
    fill_in "course[title]", with: ""
    click_on "Save"
    expect(page).to have_content "Edit Course"
    expect(page).to have_content "Title can't be blank"
  end
  
  it "redirects to the course show page when correct" do
    fill_in "course[title]", with: "New Title"
    click_on "Save"
    expect(page).to have_content "New Title"
  end
end