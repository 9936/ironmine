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

  def new_target
    @monitor_target = Emw::MonitorTarget.new({:monitor_program_id => params[:id]})
  end

  def create_target
    @monitor_target = Emw::MonitorTarget.new(params[:emw_monitor_target])
    @monitor_target.target_type=params[:target_type]
    if params[:interface_target_id].present?
      @monitor_target.target_id=params[:interface_target_id]
    elsif params[:database_target_id].present?
      @monitor_target.target_id=params[:database_target_id]
    else
      @monitor_target.target_id=params[:component_target_id]
    end
    @monitor_target.save
  end

  def remove_target
    @montior_target = Emw::MonitorTarget.find(params[:id])
    @montior_target.destroy
    respond_to do |format|
      format.js
      #format.html { redirect_to(:action => "show", :id => @montior_target.monitor_program_id) }
      #format.xml  { head :ok }
    end
  end

  def get_target_data
    targets = Emw::MonitorTarget.with_program(params[:id])

    conn_ids = []
    targets.each do |target|
      conn_ids << target.sql_conn if target.sql_conn.present?
      conn_ids << target.shell_conn if target.shell_conn.present?
    end
    conn_ids.each do |conn|
    end
    @conns = Emw::Connection.query_by_ids(conn_ids).index_by(&:id)


    #对target进行分类
    intance_ids = []
    targets.each do |target|
     # if target.target_type.eql?("INTERFACE")
        intance_ids << target.target_id
     # end
    end
    @datas = Emw::MonitorTarget.instance_targets(intance_ids)
  end

  def execute
    monitor_program = Emw::MonitorProgram.find(params[:id])
    @result = monitor_program.execute(params[:target_id])
  end

end
