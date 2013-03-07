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

    @calendar_item = Slm::CalendarItem.new(:calendar_id => @calendar.id)

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
      if @calendar.update_attributes(params[:slm_calendar])
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


  def schedule_events
    calendar = Slm::Calendar.find(params[:id])

    year_months = {}
    if params[:start] and params[:end]
      start_time = Time.at(params[:start].to_i)
      end_time = Time.at(params[:end].to_i)
    else
      start_time = Time.now - 1.month
      end_time = Time.now + 1.month
    end

    s_year, s_month = start_time.year, start_time.month
    e_year, e_month = end_time.year, end_time.month

    year_months[s_year] ||= []
    year_months[e_year] ||= []

    if s_year == e_year
      (s_month..e_month).each do |month|
        year_months[s_year] << month
      end
    else
      while start_time <= Time.parse("#{s_year}-12-31", start_time)
        year_months[s_year] << start_time.month
        start_time += 1.month
      end

      start_time = Time.parse("#{e_year}-01-01", e_year)
      while start_time <= end_time
        year_months[e_year] << start_time.month
        start_time += 1.month
      end

    end

    calendar_items = Slm::CalendarItem.with_calendar(calendar.id).with_years(year_months.keys).ordered

    events_result = []
    calendar_items.each do |item|
      month_obj = eval(item[:calendar_obj])

      year_months.each do |year, months|
        unless item[:calendar_year].eql?(year.to_s)
          next
        end
        months.each do |month|
          month_obj[month].each do |day|
            start = "#{item[:calendar_year]}-#{month}-#{day}"
            if Time.parse(start) > start_time && Time.parse(start) < end_time
              events_result << {:id => item.id, :title => "#{item[:start_at]} ~ #{item[:end_at]}", :start => start}
            end
          end if month_obj[month] and month_obj[month].any?
        end
      end
    end

    respond_to do |format|
      format.json {render :json=> events_result.uniq.to_json}
    end
  end
end
