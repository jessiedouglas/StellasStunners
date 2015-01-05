module AuthFeaturesHelper
  def sign_up_as(user)
    visit new_user_url
    
    choose(user.user_type)
    fill_in "user[username]", with: user.username
    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: user.password
    fill_in "password_confirm", with: user.password
    
    click_button "Sign Up"
  end
  
  def sign_up_as_teacher
    user = FactoryGirl.build(:teacher)
    sign_up_as(user)
  end
  
  def sign_up_as_student
    user = FactoryGirl.build(:student)
    sign_up_as(user)
  end
  
  def log_in_as(user)
    visit new_session_url
    password = user.password
    user.save!
    
    fill_in "user[un_or_email]", with: user.username
    fill_in "user[password]", with: password
    click_button "Log In"
  end
  
  def log_in_as_teacher
    user = FactoryGirl.build(:teacher)
    log_in_as(user)
  end
  
  def log_in_as_student
    user = FactoryGirl.build(:student)
    log_in_as(user)
  end
end