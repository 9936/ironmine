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
      format.json {render :json=>to_jsonp(kanbans.to_grid_json(
                                              [:kanban_code, :name,:description,:status_meaning],
                                              count))}
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
end