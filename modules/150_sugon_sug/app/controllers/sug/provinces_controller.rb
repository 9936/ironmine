class Sug::ProvincesController < ApplicationController
  def show
    @province = Sug::Province.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @province }
    end
  end


  def get_city_data
    province = Sug::Province.find(params[:id])
    cities = province.cities
    cities = cities.collect{|i| {:label=>i[:name], :value=>i.id, :id=>i.id}}
    respond_to do |format|
      format.json {render :json=> cities.to_grid_json([:label, :value], cities.count)}
    end
  end

  def get_data
    province_scope = Sug::Province.query_by_country(params[:country_id])
    provinces,count = paginate(province_scope)

    respond_to do |format|
      format.html  {
        @datas = provinces
        @count = count
      }
    end
  end

end