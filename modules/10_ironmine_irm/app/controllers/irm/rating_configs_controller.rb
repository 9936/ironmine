class Irm::RatingConfigsController < ApplicationController
  layout "application"

  # GET /irm/rating_configs
  # GET /irm/rating_configs.xml
  def index
    @rating_configs = Irm::RatingConfig.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rating_configs }
    end
  end

  # GET /irm/rating_configs/1
  # GET /irm/rating_configs/1.xml
  def show
    @rating_config = Irm::RatingConfig.find(params[:id])


    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rating_config }
    end
  end

  # GET /irm/rating_configs/new
  # GET /irm/rating_configs/new.xml
  def new
    @rating_config = Irm::RatingConfig.new_for_edit

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rating_config }
    end
  end

  # GET /irm/rating_configs/1/edit
  def edit
    @rating_config = Irm::RatingConfig.find(params[:id])
  end

  # POST /irm/rating_configs
  # POST /irm/rating_configs.xml
  def create
    @rating_config = Irm::RatingConfig.new(params[:irm_rating_config])

    respond_to do |format|
      if @rating_config.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @rating_config, :status => :created, :location => @rating_config }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rating_config.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /irm/rating_configs/1
  # PUT /irm/rating_configs/1.xml
  def update
    @rating_config = Irm::RatingConfig.find(params[:id])

    respond_to do |format|
      if @rating_config.update_attributes(params[:irm_rating_config])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rating_config.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /irm/rating_configs/1
  # DELETE /irm/rating_configs/1.xml
  def destroy
    @rating_config = Irm::RatingConfig.find(params[:id])
    @rating_config.destroy

    respond_to do |format|
      format.html { redirect_to(irm_rating_configs_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @rating_config = Irm::RatingConfig.find(params[:id])
  end

  def multilingual_update
    @rating_config = Irm::RatingConfig.find(params[:id])
    @rating_config.not_auto_mult=true
    respond_to do |format|
      if @rating_config.update_attributes(params[:irm_rating_config])
        format.html { redirect_to({:action => "show"}, :notice => 'Rating config was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rating_config.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    irm_rating_configs_scope = Irm::RatingConfig.where("1=1").includes(:rating_config_grades)
    irm_rating_configs_scope = irm_rating_configs_scope.match_value("#{Irm::RatingConfig.table_name}.name",params[:name])
    irm_rating_configs,count = paginate(irm_rating_configs_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(irm_rating_configs.to_grid_json([:code,:name,:description,:display_style], count)) }
      format.html  {
        @count = count
        @datas = irm_rating_configs
      }
    end
  end
end
