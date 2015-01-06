class TeacherStudentLinksController < ApplicationController
  def create
    
  end
  
  def destroy
    TeacherStudentLink.find(params[:id]).destroy
  end
end
