class Irm::KanbansController < ApplicationController
  def index

  end

  def show
    @kanban = Irm::Kanban.multilingual.find(params[:id])
  end

  def new
    @kanban = Irm::Kanban.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @kanban }
    end
  end

  def edit
    @kanban = Irm::Kanban.multilingual.find(params[:id])
    respond_to do |format|
      format.html
      format.xml { render :xml => @kanban}
    end
  end

  def create
    @kanban = Irm::Kanban.new(params[:irm_kanban])
    @kanban.position_code = "INCIDENT_REQUEST_PAGE"
    respond_to do |format|
      if @kanban.save
        format.html {redirect_to({:action=>"index"}, :notice =>t(:successfully_created))}
        format.xml  { render :xml => @kanban, :status => :created, :location => @kanban }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @kanban.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @kanban = Irm::Kanban.find(params[:id])
    respond_to do |format|
      if @kanban.update_attributes(params[:irm_kanban])
        format.html { redirect_to({:action=>"index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @kanban.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    kanbans_scope= Irm::Kanban.multilingual.status_meaning

    kanbans,count = paginate(kanbans_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(kanbans.to_grid_json([:kanban_code, :name,:description,:refresh_interval, :limit, :status_meaning],count))}
      format.html  {
        @count = count
        @datas = kanbans
      }
    end
  end


  def refresh_my_kanban
    @refresh_mode = params[:mode]
    @position_code = params[:position_code]
    respond_to do |format|
      format.js {render :refresh_kanban}
    end
  end



  def multilingual_edit
    @kanban = Irm::Kanban.find(params[:id])
  end

  def multilingual_update
    @kanban = Irm::Kanban.find(params[:id])
    @kanban.not_auto_mult=true
    respond_to do |format|
      if @kanban.update_attributes(params[:irm_kanban])
        format.html { render({:action=>"show"}) }
      else
        format.html { render({:action=>"multilingual_edit"}) }
      end
    end
  end

  def get_available_lanes
    owned_lanes_scope= Irm::Lane.select_all.without_kanban(params[:id]).enabled

    kanbans,count = paginate(owned_lanes_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(kanbans.to_grid_json( [:id, :lane_code, :lane_name,:lane_description, :limit],count))}
      format.html {
        @datas = kanbans
        @count = count
        render_html_data_table
      }
    end
  end

  def get_owned_lanes
    owned_lanes_scope= Irm::Kanban.where(:id => params[:id]).with_lanes.order("display_sequence ASC")

#    kanbans,count = paginate(owned_lanes_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(owned_lanes_scope.to_grid_json(
                                              [:irm_lane_id, :lane_code, :lane_name,:lane_description],
                                              50))}
      format.html  {
        @count = owned_lanes_scope.count
        @datas = owned_lanes_scope
      }
    end
  end

  def add_lanes
    return_url=params[:return_url]
    params[:lane_ids].split(",").each do |p|
      Irm::KanbanLane.create({:kanban_id => params[:id],
                               :lane_id => p,
                               :display_sequence => Irm::KanbanLane.max_display_seq(params[:id]) + 1})
      puts("+++++++++++++++++++++++++++++++++++" + p)
    end

    flash[:notice] = t(:successfully_updated)
    if return_url.blank?
      redirect_to({:action=>"add_lanes", :id=> params[:id]})
    else
      redirect_to(return_url)
    end
  end

  def select_lanes
    @return_url= params[:return_url] || request.env['HTTP_REFERER']
    @kanban = Irm::Kanban.find(params[:id])
  end

  def delete_lane
    return_url=params[:return_url]
    kanbanlane = Irm::KanbanLane.where(:kanban_id => params[:kanban_id], :lane_id => params[:lane_id]).first
    kanbanlane.destroy
    if return_url.blank?
      redirect_to({:action=>"show", :id=> params[:kanban_id]})
    else
      redirect_to(return_url)
    end
  end

  def up_lane
    return_url=params[:return_url]
    kanbanlane = Irm::KanbanLane.where(:kanban_id => params[:kanban_id], :lane_id => params[:lane_id]).first

    pre_lane = kanbanlane.pre_lane
    pre_display_sequence = pre_lane.display_sequence
    cur_display_sequence = kanbanlane.display_sequence
    kanbanlane.update_attribute(:display_sequence, pre_display_sequence)
    pre_lane.update_attribute(:display_sequence, cur_display_sequence)

    if return_url.blank?
      redirect_to({:action=>"show", :id=> params[:kanban_id]})
    else
      redirect_to(return_url)
    end
  end

  def down_lane
    return_url=params[:return_url]
    kanbanlane = Irm::KanbanLane.where(:kanban_id => params[:kanban_id], :lane_id => params[:lane_id]).first

    next_lane = kanbanlane.next_lane
    next_display_sequence = next_lane.display_sequence
    cur_display_sequence = kanbanlane.display_sequence

    kanbanlane.update_attribute(:display_sequence, next_display_sequence)
    next_lane.update_attribute(:display_sequence, cur_display_sequence)

    if return_url.blank?
      redirect_to({:action=>"show", :id=> params[:kanban_id]})
    else
      redirect_to(return_url)
    end
  end
end