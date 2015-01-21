class CourseAssignmentsController < ApplicationController
  def create
    
  end
  
  def destroy
    link = CourseAssignment.find(params[:id])
    course = link.course
    link.destroy
    redirect_to course_url(course)
  end
end
