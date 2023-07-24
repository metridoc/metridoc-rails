class ApplicationController < ActionController::Base

  def create
    @input_school=params[:school]
    @input_library=params[:libary]
  end
  
end
