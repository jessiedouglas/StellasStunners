feature "user show page" do
  before(:each) do
    user = FactoryGirl.build(:student, username: "Halle Berry")
    log_in_as(user)
    visit user_url(user)
  end
  
  it "shows username" do
    expect(page).to have_content "Halle Berry"
  end
  
  it "has a link to edit user info" do
    click_link "Edit My Info"
    expect(page).to have_content "Edit My Info"
    expect(page).to have_content "Email"
  end
end

feature "user edit page" do
  before(:each) do
    user = FactoryGirl.build(:student, username: "Halle Berry")
    log_in_as(user)
    visit edit_user_url(user)
  end
  
  it "says 'Edit My Info'" do
    expect(page).to have_content "Edit My Info"
  end
  
  it "has correct fields" do
    expect(page).to have_field "Username"
    expect(page).to have_field "Email"
  end
  
  it "has a submit button" do
    expect(page).to have_button "Update"
  end
  
  it "allows correct input" do
    fill_in "Username", with: "Tom Cruise"
    click_button "Update"
    expect(page).to have_content "Tom Cruise"
  end
  
  it "shows errors for incorrect input" do
    fill_in "Username", with: ""
    click_button "Update"
    expect(page).to have_content "Username can't be blank"
  end
  
  it "has a way to cancel the update" do
    click_link "Cancel"
    expect(page).to_not have_field "Username"
  end
end