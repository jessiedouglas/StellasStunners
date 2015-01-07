require 'spec_helper'

describe CoursesController do
  context "GET show" do
    it "expects the user to be the course creator or in the course"
    
    it "assigns @course and @students"
    
    it "renders the show template"
  end
  
  context "GET new" do
    it "expects the user to be logged in"
    
    it "assigns @course"
    
    it "renders the new template"
  end
  
  context "POST create" do
    it "expects the user to be logged in"
    
    it "assigns @course"
    
    it "redirects successful create to course show page"
    
    context "unsuccessful create" do
      it "sets flash[:errors]"
      
      it "re-renders the new template"
    end
  end
  
  context "GET edit" do
    it "expects the user to be the course creator"
    
    it "assigns @course"
    
    it "renders the edit template"
  end
  
  context "PUT update" do
    it "expects the user to be the course creator"
    
    it "assigns @course"
    
    it "redirects successful create to course show page"
    
    context "unsuccessful create" do
      it "sets flash[:errors]"
      
      it "re-renders the edit template"
    end
  end
  
  context "DELETE destroy" do
    it "expects the user to be the course creator"
    
    it "destroys the post"
    
    it "redirects to the user show page"
  end
end
