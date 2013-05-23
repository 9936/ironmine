class Gtd::NotifyProgramsController < ApplicationController
  # GET /notify_programs
  # GET /notify_programs.xml
  def index
    @notify_programs = Gtd::NotifyProgram.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notify_programs }
    end
  end

  # GET /notify_programs/1
  # GET /notify_programs/1.xml
  def show
    @notify_program = Gtd::NotifyProgram.multilingual.find(params[:id])
    if @notify_program.notify_type.eql?("EMAIL")
      @notify_program = Gtd::NotifyProgram.with_all.with_mail_alert.multilingual.find(params[:id])
    end


    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @notify_program }
    end
  end

  # GET /notify_programs/new
  # GET /notify_programs/new.xml
  def new
    @notify_program = Gtd::NotifyProgram.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @notify_program }
    end
  end

  # GET /notify_programs/1/edit
  def edit
    @notify_program = Gtd::NotifyProgram.multilingual.find(params[:id])
  end

  # POST /notify_programs
  # POST /notify_programs.xml
  def create
    @notify_program = Gtd::NotifyProgram.new(params[:gtd_notify_program])

    respond_to do |format|
      if @notify_program.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @notify_program, :status => :created, :location => @notify_program }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @notify_program.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notify_programs/1
  # PUT /notify_programs/1.xml
  def update
    @notify_program = Gtd::NotifyProgram.find(params[:id])

    respond_to do |format|
      if @notify_program.update_attributes(params[:gtd_notify_program])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @notify_program.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /notify_programs/1
  # DELETE /notify_programs/1.xml
  def destroy
    @notify_program = Gtd::NotifyProgram.find(params[:id])
    @notify_program.destroy

    respond_to do |format|
      format.html { redirect_to(notify_programs_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @notify_program = Gtd::NotifyProgram.find(params[:id])
  end

  def multilingual_update
    @notify_program = Gtd::NotifyProgram.find(params[:id])
    @notify_program.not_auto_mult=true
    respond_to do |format|
      if @notify_program.update_attributes(params[:gtd_notify_program])
        format.html { redirect_to({:action => "show"}, :notice => 'Notify program was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @notify_program.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    notify_programs_scope = Gtd::NotifyProgram.multilingual
    notify_programs_scope = notify_programs_scope.match_value("#{Gtd::NotifyProgramsTl.table_name}.name", params[:name])
    notify_programs,count = paginate(notify_programs_scope)
    respond_to do |format|
      format.html  {
        @datas = notify_programs
        @count = count
      }
      format.json {render :json=>to_jsonp(notify_programs.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end
end
