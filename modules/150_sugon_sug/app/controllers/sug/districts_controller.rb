class Sug::DistrictsController < ApplicationController

  def get_data
    districts_scope = Sug::District.query_by_city(params[:city_id])
    districts,count = paginate(districts_scope)

    respond_to do |format|
      format.html  {
        @datas = districts
        @count = districts.count
      }
    end
  end

end