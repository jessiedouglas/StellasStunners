feature "Signing up" do
  before(:each) do
    visit new_user_url
  end
  
  it "has a link to Log In" do
    click_link "Log In"
    expect(page).to have_content "Username or Email"
  end
  
  it "says 'Sign Up' on the page" do
    expect(page).to have_content("Sign Up")
  end
  
  it "has correct fields" do
    expect(page).to have_field "Username"
    expect(page).to have_field "Email"
    expect(page).to have_field "Password"
    expect(page).to have_field "Confirm Password"
    expect(page).to have_content "Student"
    expect(page).to have_content "Teacher"
  end
  
  it "has a submit button" do
    expect(page).to have_button "Sign Up"
  end
  
  it "allows a correct form to be submitted" do
    sign_up_as_teacher
    expect(page).to have_content "Logged in as"
    click_button "Log Out"
    
    sign_up_as_student
    expect(page).to have_content "Logged in as"
  end
  
  it "shows errors for missing/incorrect fields" do
    user = FactoryGirl.build(:student, username: "")
    sign_up_as(user)
    expect(page).to have_content "Username can't be blank"
    
    visit new_user_url
    user = FactoryGirl.build(:student)
    fill_in "user[username]", with: user.username
    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: user.password
    fill_in "password_confirm", with: user.password
    click_button "Sign Up"
    expect(page).to have_content "Choose an account type."
    
    visit new_user_url
    user = FactoryGirl.build(:student, password: "password")
    choose(user.user_type)
    fill_in "user[username]", with: user.username
    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: user.password
    fill_in "password_confirm", with: "aaaaaaaaa"
    click_button "Sign Up"
    expect(page).to have_content "Passwords do not match"
  end
end

feature "Signing in" do
  before(:each) do
    visit new_session_url
  end
  
  it "has a link to sign up" do
    click_link "Sign Up"
    expect(page).to have_content "Confirm Password"
  end
  
  it "says 'Log In'" do
    expect(page).to have_content "Log In"
  end
  
  it "has correct fields" do
    expect(page).to have_field "Username or Email"
    expect(page).to have_field "Password"
  end
  
  it "allows a correct form to be submitted" do
    log_in_as_teacher
    expect(page).to have_content "Logged in as"
  end
  
  it "shows errors for missing/incorrect fields" do
    FactoryGirl.create(:student)
    users = [
            FactoryGirl.build(:student, username: "thisisanincorrectusername"),
            FactoryGirl.build(:student, username: ""),
            FactoryGirl.build(:student, password: "")
          ]
          
    users.each do |user|
      visit new_session_url
      fill_in "user[un_or_email]", with: user.username
      fill_in "user[password]", with: user.password
      click_button "Log In"
      expect(page).to have_content "Incorrect username/email or password"
    end
  end
end