class Emw::MonitorProgramsController < ApplicationController
  layout "application_full"

  # GET /monitor_programs
  # GET /monitor_programs.xml
  def index
  end

  # GET /monitor_programs/1
  # GET /monitor_programs/1.xml
  def show
    @monitor_program = Emw::MonitorProgram.select_all.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @monitor_program }
    end
  end

  # GET /monitor_programs/new
  # GET /monitor_programs/new.xml
  def new
    @monitor_program = Emw::MonitorProgram.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @monitor_program }
    end
  end

  # GET /monitor_programs/1/edit
  def edit
    @monitor_program = Emw::MonitorProgram.find(params[:id])
  end

  # POST /monitor_programs
  # POST /monitor_programs.xml
  def create
    @monitor_program = Emw::MonitorProgram.new(params[:emw_monitor_program])
    @monitor_program.time_mode = YAML.dump(params[:time_mode_obj])

    respond_to do |format|
      if @monitor_program.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @monitor_program, :status => :created, :location => @monitor_program }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @monitor_program.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /monitor_programs/1
  # PUT /monitor_programs/1.xml
  def update
    @monitor_program = Emw::MonitorProgram.find(params[:id])
    @monitor_program.time_mode = YAML.dump(params[:time_mode_obj])

    respond_to do |format|
      if @monitor_program.update_attributes(params[:emw_monitor_program])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @monitor_program.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /monitor_programs/1
  # DELETE /monitor_programs/1.xml
  def destroy
    @monitor_program = Emw::MonitorProgram.find(params[:id])
    @monitor_program.destroy

    respond_to do |format|
      format.html { redirect_to(monitor_programs_url) }
      format.xml  { head :ok }
    end
  end


  def get_data
    monitor_programs_scope = Emw::MonitorProgram.select_all
    monitor_programs_scope = monitor_programs_scope.match_value("monitor_program.name",params[:name])
    monitor_programs,count = paginate(monitor_programs_scope)
    respond_to do |format|
      format.html  {
        @datas = monitor_programs
        @count = count
      }
      format.json {render :json=>to_jsonp(monitor_programs.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end
end
