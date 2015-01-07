###FIX SO IT WORKS WITH THE BEFORE FILTERS
require 'spec_helper'

describe UsersController do
  context "GET show" do
    let(:user) { stub_model User, id: 5, user_type: "Student", name: "hello" }
    let(:current_user) { stub_model User, id: 5, user_type: "Student", name: "hello" }
    
    it "expects user to be the current user"
    
    it "assigns @user" do
      get :show, id: "5"
      expect(assigns(:user)).to eq(user)
    end
    
    it "renders show template" do
      get :show, id: "5"
      expect(response).to render_template(:show)
    end
  end
  
  context "GET new" do
    before(:each) do
      get :new
    end
    
    it "expects user to be logged out"
    
    it "assigns a blank user" do
      expect(assigns(:user).class).to eq(User)
    end
    
    it "renders new template" do
      expect(response).to render_template(:new)
    end
  end
  
  context "POST create" do
    
    it "expects user to be logged out"
    
    it "does not allow user type Admin" do
      post :create, { user: { name: "hello", email: "hi@hi.com", password: "password", user_type: "Admin"}, password_confirm: "password" }
      expect(response).to render_template(:new)
    end
    
    it "checks to see if passwords match" do
      post :create, { user: { name: "hello", email: "hi@hi.com", password: "password", user_type: "Student"}, password_confirm: "password" }
      user = User.find_by_name("hello")
      expect(response).to redirect_to(user_url(user))
      
      post :create, { user: { name: "hello", email: "hi@hi.com", password: "password", user_type: "Student"}, password_confirm: "aaaaaaaa" }
      expect(response).to render_template(:new)
    end
    
    context "successful create" do
      before(:each) do
        post :create, { user: { name: "hello", email: "hi@hi.com", password: "password", user_type: "Student"}, password_confirm: "password" }
      end
    
      it "assigns @user" do
        user = assigns(:user)
        expect(user.class).to eq(User)
        expect(user.name).to eq("hello")
        expect(user.email).to eq("hi@hi.com")
      end
      
      it "logs in user"
    
      it "redirects to user show page" do
        user = User.find_by_name("hello")
        expect(response).to redirect_to(user_url(user))
      end
    end
    
    context "unsuccessful create" do
      before(:each) do
        post :create, { user: { name: "", email: "", password: "", user_type: "" } }
      end
      
      it "assigns @user" do
        expect(assigns(:user).class).to eq(User)
      end
      
      it "assigns flash[:errors]" do
        expect(flash[:errors]).to eq(assigns(:user).errors.full_messages)
      end
      
      it "re-renders new template" do
        expect(response).to render_template(:new)
      end
    end
  end
  
  context "GET edit" do
    before(:each) do
      user = FactoryGirl.create(:student, name: "hello")
      get :edit, { id: user.id.to_s }
    end
    
    it "expects user to be logged in"
    
    it "assigns @user" do
      user = assigns(:user)
      expect(user.class).to eq(User)
      expect(user.name).to eq("hello")
    end
    
    it "renders edit template" do
      expect(response).to render_template(:edit)
    end
  end
  
  context "PATCH update" do
    
    it "expects user to be logged in"
    
    context "successful update" do
      before(:each) do
        user = FactoryGirl.create(:student, name: "old", email: "a@a.com")
        patch :update, { user: { name: "new" }, id: user.id.to_s }
      end
      
      it "assigns @user" do
        user = assigns(:user)
        expect(user.class).to eq(User)
        expect(user.email).to eq("a@a.com")
      end
      
      it "updates properties" do
        expect(assigns(:user).name).to eq("new")
      end
      
      it "redirects to user show page" do
        user = User.find_by_email("a@a.com")
        expect(response).to redirect_to(user_url(user))
      end
    end
    
    context "unsuccessful update" do
      before(:each) do
        user = FactoryGirl.create(:student, name: "hello", email: "a@a.com")
        patch :update, { user: { name: "", password: "" }, id: user.id.to_s }
      end
      
      it "assigns @user" do
        user = assigns(:user)
        expect(user.class).to eq(User)
        expect(user.email).to eq("a@a.com")
      end
      
      it "doesn't update properties" do
        user = User.find_by_email("a@a.com")
        expect(user.name).to eq("hello")
      end
      
      it "assigns flash[:errors]" do
        expect(flash[:errors]).to eq(assigns(:user).errors.full_messages)
      end
      
      it "re-renders edit template" do
        expect(response).to render_template(:edit)
      end
    end
  end
end
