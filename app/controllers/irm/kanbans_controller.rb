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
    range_types = [[Irm::Company,"C"],[Irm::Organization,"O"],[Irm::Department,"D"],[Irm::Role,"R"],[Irm::Person, "P"]]
    respond_to do |format|
      if @kanban.save
        if params[:selected_ranges] && params[:selected_ranges].present?
          selected_ranges = params[:selected_ranges].split(",")

          selected_ranges.each do |range_str|
            next unless range_str.strip.present?
            range = range_str.split("#")
            range_type = range_types.detect{|i| i[1].eql?(range[0])}

            Irm::KanbanRange.create({:kanban_id => @kanban.id,
                                      :range_type => range_type[0].name,
                                      :range_id => range[1]})
          end if selected_ranges.any?
        end

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
    range_types = [[Irm::Company,"C"],[Irm::Organization,"O"],[Irm::Department,"D"],[Irm::Role,"R"],[Irm::Person,"P"]]

    respond_to do |format|
      if @kanban.update_attributes(params[:irm_kanban])
        if params[:selected_ranges] && params[:selected_ranges].present?
          selected_ranges = params[:selected_ranges].split(",")

          range_records = @kanban.kanban_ranges
          range_records.each do |t|
            type_short = range_types.detect{|i| i[0].name.eql?(t.range_type)}
            t.destroy unless selected_ranges.include?(type_short[1]+"#"+t.range_id.to_s)
          end
          ranges_array = @kanban.kanban_ranges.collect{|p| [p.range_type, p.range_id]}

          selected_ranges.each do |range_str|
            next unless range_str.strip.present?
            range = range_str.split("#")
            range_type = range_types.detect{|i| i[1].eql?(range[0])}
            next if ranges_array.include?([range_type[0].name, range[1].to_i])

            Irm::KanbanRange.create({:kanban_id => @kanban.id,
                                      :range_type => range_type[0].name,
                                      :range_id => range[1]})
          end
        end
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
      format.json {render :json=>to_jsonp(kanbans.to_grid_json(
                                              [:kanban_code, :name,:description, :refresh_interval,:status_meaning],
                                              count))}
    end
  end

  def get_available_lanes

  end

  def get_owned_lanes
    owned_lanes_scope= Irm::Kanban.with_lanes

#    kanbans,count = paginate(owned_lanes_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(owned_lanes_scope.to_grid_json(
                                              [:irm_lane_id, :lane_code, :name,:description, :lane_limit],
                                              50))}
    end
  end

  def add_lanes

  end

  def select_lanes
    @kanban = Irm::Kanban.find(params[:id])
  end
end