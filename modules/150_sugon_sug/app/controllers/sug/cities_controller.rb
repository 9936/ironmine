class Sug::CitiesController < ApplicationController
  def show
    @city = Sug::City.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @city }
    end
  end

  def get_district_data
    city = Sug::City.find(params[:id])
    districts = city.districts
    districts = districts.collect{|i| {:label=>i[:name], :value=>i.id, :id=>i.id}}
    respond_to do |format|
      format.json {render :json=> districts.to_grid_json([:label, :value], districts.count)}
    end
  end

  def get_data
    cities_scope = Sug::City.query_by_province(params[:province_id])
    cities,count = paginate(cities_scope)

    respond_to do |format|
      format.html  {
        @datas = cities
        @count = cities.count
      }
    end
  end

end