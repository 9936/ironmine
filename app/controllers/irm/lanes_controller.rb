class Irm::LanesController < ApplicationController
  def index

  end

  def edit
    @lane = Irm::Lane.multilingual.find(params[:id])
  end

  def update
    @lane = Irm::Lane.find(params[:id])

    respond_to do |format|
      if @lane.update_attributes(params[:irm_lane])
        format.html { redirect_to({:action=>"index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lane.errors, :status => :unprocessable_entity }
      end
    end
  end

  def new
    @lane = Irm::Lane.new
  end

  def create
    @lane = Irm::Lane.new(params[:irm_lane])
    respond_to do |format|
      if @lane.save
        format.html {redirect_to({:action=>"index"}, :notice =>t(:successfully_created))}
        format.xml  { render :xml => @lane, :status => :created, :location => @lane }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @lane.errors, :status => :unprocessable_entity }
      end
    end

  end

  def get_data
    lanes_scope= Irm::Lane.multilingual.status_meaning

    lanes,count = paginate(lanes_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(lanes.to_grid_json(
                                              [:lane_code, :name,:description, :limit,:status_meaning],
                                              count))}
    end
  end

  def show

  end
end