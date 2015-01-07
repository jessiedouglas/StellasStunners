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