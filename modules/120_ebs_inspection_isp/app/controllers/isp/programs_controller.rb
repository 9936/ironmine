class Isp::ProgramsController < ApplicationController
  # GET /isp/programs
  # GET /isp/programs.xml
  def index
    @isp_programs = Isp::Program.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @isp_programs }
    end
  end

  # GET /isp/programs/1
  # GET /isp/programs/1.xml
  def show
    @isp_program = Isp::Program.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @isp_program }
    end
  end

  # GET /isp/programs/new
  # GET /isp/programs/new.xml
  def new
    @isp_program = Isp::Program.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @isp_program }
    end
  end

  # GET /isp/programs/1/edit
  def edit
    @isp_program = Isp::Program.multilingual.find(params[:id])
  end

  # POST /isp/programs
  # POST /isp/programs.xml
  def create
    @isp_program = Isp::Program.new(params[:isp_program])

    respond_to do |format|
      if @isp_program.save
        format.html { redirect_to({:action => "show", :id => @isp_program}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @isp_program, :status => :created, :location => @isp_program }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @isp_program.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /isp/programs/1
  # PUT /isp/programs/1.xml
  def update
    @isp_program = Isp::Program.find(params[:id])

    respond_to do |format|
      if @isp_program.update_attributes(params[:isp_program])
        format.html { redirect_to({:action => "show", :id => @isp_program }, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @isp_program.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /isp/programs/1
  # DELETE /isp/programs/1.xml
  def destroy
    @isp_program = Isp::Program.find(params[:id])
    @isp_program.destroy

    respond_to do |format|
      format.html { redirect_to(isp_programs_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @isp_program = Isp::Program.find(params[:id])
  end

  def multilingual_update
    @isp_program = Isp::Program.find(params[:id])
    @isp_program.not_auto_mult=true
    respond_to do |format|
      if @isp_program.update_attributes(params[:isp_program])
        format.html { redirect_to({:action => "show"}, :notice => 'Program was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @isp_program.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    isp_programs_scope = Isp::Program.multilingual
    isp_programs_scope = isp_programs_scope.match_value("#{Isp::ProgramsTl.table_name}.name", params[:name])
    isp_programs,count = paginate(isp_programs_scope)
    respond_to do |format|
      format.html  {
        @datas = isp_programs
        @count = count
      }
      format.json {render :json=>to_jsonp(isp_programs.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end

  def new_execute
    #puts "==============================="
    #a = Isp::Program.includes(:connections => [{:check_items => :check_parameters}])
    #puts a
    #puts "==============================="
    @program = Isp::Program.includes(:connections => [{:check_items => :check_parameters}]).multilingual.find(params[:id])
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @program }
    end
  end

  def new_trigger
    @program = Isp::Program.includes(:connections => [{:check_items => :check_parameters}]).multilingual.find(params[:id])
    if @program.program_triggers.any?
      @program_trigger = @program.program_triggers.first
    else
      @program_trigger = Isp::ProgramTrigger.new(:program_id => params[:id])
    end
  end

  def create_trigger
    @program_trigger =  Isp::ProgramTrigger.query_trigger(params[:isp_program_trigger][:program_id])
    if @program_trigger.present?
      @program_trigger.destroy
    end
    @program_trigger = Isp::ProgramTrigger.new(params[:isp_program_trigger])
    @program_trigger.time_mode= YAML.dump(params[:time_mode_obj])

    @program_trigger.isp_program_str = {:isp_program => params[:isp_program], :isp_check_item => params[:isp_check_item] }.to_s

    respond_to do |format|
      if @program_trigger.save
        @program_trigger.create_receiver_from_str
        format.html { redirect_to({:action => "show",:id=>@program_trigger.program_id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @program_trigger, :status => :created, :location => @program_trigger }
      else
        @program = Isp::Program.multilingual.find(params[:isp_program_trigger][:program_id])
        format.html { render :action => "new_trigger" }
        format.xml  { render :xml => @program_trigger.errors, :status => :unprocessable_entity }
      end
    end
  end

  def create_execute
    @program = Isp::Program.find(params[:id])

    @program.attributes = params[:isp_program]

    execute_context = {}
    @program.connections.each do |c|
      #设置巡检项中的参数
      c.check_items.each do |check_item|
        check_item.check_parameters.each do |p|
          p.value = params[:isp_check_item][c.id][check_item.id][p.id][:value]
        end
      end

      execute_context.merge!({c.object_symbol=>{:username=>c.username,:password=>c.password,:host=>c.host}})
    end

    @results = @program.execute(execute_context)
    @doc_alerts = @program.check_alert(@results)
    @doc = @program.generate_report(@results)
  end
end
