class Irm::LanesController < ApplicationController
  def index

  end

  def edit
    @lane = Irm::Lane.multilingual.find(params[:id])
  end

  def update
    @lane = Irm::Lane.find(params[:id])

    respond_to do |format|
      if @lane.update_attributes(params[:irm_lane]) && (@lane.update_attribute(:limit, 10) if @lane.limit.nil? || @lane.limit <= 0)
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
    @lane.limit = 10 if @lane.limit.nil? || @lane.limit <= 0
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
                                              [:lane_code, :name,:description, :limit,:status_meaning, :background_color, :font_color],
                                              count))}
    end
  end

  def show
    @lane = Irm::Lane.multilingual.find(params[:id])
  end

  def select_cards
    @return_url= params[:return_url] || request.env['HTTP_REFERER']
    @lane = Irm::Lane.find(params[:id])
  end

  def get_owned_cards
    owned_cards_scope= Irm::Lane.with_cards(params[:id])

    respond_to do |format|
      format.json {render :json=>to_jsonp(owned_cards_scope.to_grid_json(
                                              [:irm_card_id, :card_code, :card_name,:card_description, :background_color],50))}
    end
  end

  def delete_card
    return_url=params[:return_url]
    lanecard = Irm::LaneCard.where(:lane_id => params[:lane_id], :card_id => params[:card_id]).first
    lanecard.destroy
    if return_url.blank?
      redirect_to({:action=>"show", :id=> params[:lane_id]})
    else
      redirect_to(return_url)
    end
  end

  def add_cards
    return_url=params[:return_url]
    params[:irm_lane_cards][:ids].each do |p|
      Irm::LaneCard.create({:lane_id => params[:id],
                             :card_id => p})
    end

    flash[:notice] = t(:successfully_updated)
    if return_url.blank?
      redirect_to({:action=>"add_cards", :id=> params[:id]})
    else
      redirect_to(return_url)
    end
  end

  def get_available_cards
    owned_cards_scope= Irm::Card.select_all.without_lane(params[:id]).enabled
    respond_to do |format|
      format.json {render :json=>to_jsonp(owned_cards_scope.to_grid_json(
                                          [:card_code, :card_name,:card_description, :background_color],50))}
    end
  end

  def multilingual_edit
    @lane = Irm::Lane.find(params[:id])
  end

  def multilingual_update
    @lane = Irm::Lane.find(params[:id])
    @lane.not_auto_mult=true
    respond_to do |format|
      if @card.update_attributes(params[:irm_lane])
        format.html { render({:action=>"show"}) }
      else
        format.html { render({:action=>"multilingual_edit"}) }
      end
    end
  end
end