class PopulationController < ActionController::Base

  def create
    @input_school=params[:school]
    @input_library=params[:libary]
    puts @input_school
    puts @input_library
  end
  
end
