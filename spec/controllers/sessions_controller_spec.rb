require 'spec_helper'

describe SessionsController do
  context "GET new" do
    before (:each) do
      get :new
    end
    
    it "expects user to be logged out"
    
    it "assigns @user" do
      expect(assigns(:user).class).to eq(User)
    end
    
    it "renders new template" do 
      expect(response).to render_template(:new)
    end
  end
  
  context "POST create" do
    it "expects user to be logged out"
    
    context "successful create" do
      before(:each) do
        user = FactoryGirl.create(:student, name: "hello", email: "hi@hi.com", password: "password")
        post :create, { user: { email: "hi@hi.com", password: "password" } }
      end
      
      it "logs in user"
      
      it "assigns @user" do
        expect(assigns(:user).class).to eq(User)
        expect(assigns(:user).name).to eq("hello")
      end
    
      it "redirects to user show page" do
        user = User.find_by_name("hello")
        expect(response).to redirect_to(user_url(user))
      end
    end
    
    context "unsuccessful create" do
      before(:each) do
        user = FactoryGirl.create(:student, name: "hello", email: "hi@hi.com", password: "password")
        post :create, { user: { email: "hi@hi.com", password: "asdl;kfj" } }
      end
      
      it "doesn't show an incorrectly entered/nonexistant user" do
        expect(assigns(:user)).to be_nil
        
        post :create, { user: { email: "bobby@o.com", password: "asdl;kfj" } }
        expect(assigns(:user)).to be_nil
      end
      
      it "assigns @user" do
        expect(assigns(:user)).to be_nil
      end
      
      it "assigns flash[:errors]" do
        expect(flash[:errors]).to eq(["Incorrect email/password combination"])
      end
      
      it "renders new template" do
        expect(response).to render_template(:new)
      end
    end
  end
  
  context "DELETE destroy" do
    before(:each) do
      user = FactoryGirl.create(:student)
      delete :destroy, { id: user.id.to_s }
    end
    
    it "expects user to be logged in"
    
    it "logs out user"
    
    it "redirects to log in page" do
      expect(response).to redirect_to(new_session_url)
    end
  end
end
