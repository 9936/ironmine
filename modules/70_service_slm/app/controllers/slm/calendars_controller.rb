class Slm::CalendarsController < ApplicationController
  # GET /calendars
  # GET /calendars.xml
  def index
    @calendars = Slm::Calendar.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @calendars }
    end
  end

  # GET /calendars/1
  # GET /calendars/1.xml
  def show
    @calendar = Slm::Calendar.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @calendar }
    end
  end

  # GET /calendars/new
  # GET /calendars/new.xml
  def new
    @calendar = Slm::Calendar.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @calendar }
    end
  end

  # GET /calendars/1/edit
  def edit
    @calendar = Slm::Calendar.multilingual.find(params[:id])
  end

  # POST /calendars
  # POST /calendars.xml
  def create
    @calendar = Slm::Calendar.new(params[:slm_calendar])
    @calendar.external_system_id = Irm::ExternalSystem.current_system.id
    respond_to do |format|
      if @calendar.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @calendar, :status => :created, :location => @calendar }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @calendar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /calendars/1
  # PUT /calendars/1.xml
  def update
    @calendar = Slm::Calendar.find(params[:id])

    respond_to do |format|
      if @calendar.update_attributes(params[:slm_calendar])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @calendar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /calendars/1
  # DELETE /calendars/1.xml
  def destroy
    @calendar = Slm::Calendar.find(params[:id])
    @calendar.destroy

    respond_to do |format|
      format.html { redirect_to(calendars_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @calendar = Slm::Calendar.find(params[:id])
  end

  def multilingual_update
    @calendar = Slm::Calendar.find(params[:id])
    @calendar.not_auto_mult=true
    respond_to do |format|
      if @calendar.update_attributes(params[:calendar])
        format.html { redirect_to({:action => "show"}, :notice => 'Calendar was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @calendar.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    calendars_scope = Slm::Calendar.multilingual.with_system(Irm::ExternalSystem.current_system.id)
    calendars_scope = calendars_scope.match_value("#{Slm::CalendarsTl.table_name}.name", params[:name])
    calendars,count = paginate(calendars_scope)
    respond_to do |format|
      format.html  {
        @datas = calendars
        @count = count
      }
      format.json {render :json=>to_jsonp(calendars.to_grid_json([:name,:description],count))}
    end
  end
end
