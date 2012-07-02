class Irm::RatingsController < ApplicationController

  def create
    Irm::Rating.create(:person_id=>Irm::Person.current.id,:bo_name=>params[:bo_name],:rating_object_id=>params[:rating_object_id],:grade=>params[:grade])
    @result = Irm::Rating.group_by_object_grade(params[:bo_name],params[:rating_object_id])

  end

end
