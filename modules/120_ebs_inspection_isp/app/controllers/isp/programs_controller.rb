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
end
