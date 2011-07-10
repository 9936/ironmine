class Irm::KanbansController < ApplicationController
  def index

  end

  def show

  end

  def new
    @kanban = Irm::Kanban.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @kanban }
    end
  end

  def edit

  end

  def create
    @kanban = Irm::Kanban.new(params[:irm_kanban])
    range_types = [[Irm::Company,"C"],[Irm::Organization,"O"],[Irm::Department,"D"],[Irm::Role,"R"]]
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

  end

  def get_data
    kanbans_scope= Irm::Kanban.multilingual.status_meaning

    kanbans,count = paginate(kanbans_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(kanbans.to_grid_json(
                                              [:name,:description, :refresh_interval,:status_meaning],
                                              count))}
    end
  end
end