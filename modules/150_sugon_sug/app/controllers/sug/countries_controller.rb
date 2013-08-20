class Sug::CountriesController < ApplicationController

  def index

  end

  def new
    @country = Sug::Country.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @country }
    end
  end

  def create
    @country = Sug::Country.new(params[:sug_country])


  end

  def show
    @country = Sug::Country.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @country }
    end
  end

  def edit
    @country = Sug::Country.find(params[:id])
  end

  def update

  end

  def get_province_data
    country = Sug::Country.find(params[:id])
    provinces = country.provinces
    provinces = provinces.collect{|i| {:label=>i[:name], :value=>i.id, :id=>i.id}}
    respond_to do |format|
      format.json {render :json=> provinces.to_grid_json([:label, :value], provinces.count)}
    end
  end

  def get_data
    countries_scope = Sug::Country
    countries,count = paginate(countries_scope)

    respond_to do |format|
      format.html  {
        @datas = countries
        @count = countries.count
      }
    end
  end

end