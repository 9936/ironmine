class Slm::CalendarItemsController < ApplicationController
  # GET /calendar_items/1
  # GET /calendar_items/1.xml
  def show
    @calendar_item = Slm::CalendarItem.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @calendar_item }
    end
  end

  # GET /calendar_items/new
  # GET /calendar_items/new.xml
  def new
    @calendar_item = Slm::CalendarItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @calendar_item }
    end
  end

  # GET /calendar_items/1/edit
  def edit
    @calendar_item = Slm::CalendarItem.multilingual.find(params[:id])
  end

  # POST /calendar_items
  # POST /calendar_items.xml
  def create
    @calendar_item = Slm::CalendarItem.new(params[:slm_calendar_item])
    @calendar_item.weeks_str = params[:week_str]

    @calendar_item.hand_calendar_item

    respond_to do |format|
      format.html { redirect_to({:controller => "slm/calendars", :action => "show", :id => params[:calendar_id]}, :notice => t(:successfully_created)) }
      format.xml  { render :xml => @calendar_item, :status => :created, :location => @calendar_item }
    end
  end

  # PUT /calendar_items/1
  # PUT /calendar_items/1.xml
  def update
    @calendar_item = Slm::CalendarItem.find(params[:calendar_item_id])
    @calendar_item.start_time = params[:calendar_date]

    if @calendar_item && @calendar_item.start_time.present?
      @calendar_item.hand_calendar_item
    end

    respond_to do |format|
      format.html { redirect_to({:controller => "slm/calendars", :action => "show", :id => params[:calendar_id]}, :notice => t(:successfully_created)) }
      format.xml  { render :xml => @calendar_item, :status => :created, :location => @calendar_item }
    end
  end

  # DELETE /calendar_items/1
  # DELETE /calendar_items/1.xml
  def destroy
    @calendar_item = Slm::CalendarItem.find(params[:id])
    year = params[:year]
    month = params[:month]
    date = params[:date]

    if year && month && date
      @calendar_item.remove_schedule(year, month, date)
    end

    respond_to do |format|
      format.json {render :json=> {:success => true}}
    end
  end

  def multilingual_edit
    @calendar_item = Slm::CalendarItem.find(params[:id])
  end

  def multilingual_update
    @calendar_item = Slm::CalendarItem.find(params[:id])
    @calendar_item.not_auto_mult=true
    respond_to do |format|
      if @calendar_item.update_attributes(params[:slm_calendar_item])
        format.html { redirect_to({:action => "show"}, :notice => 'Calendar item was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @calendar_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    calendar_items_scope = Slm::CalendarItem.multilingual.with_calendar(params[:calendar_id])
    calendar_items_scope = calendar_items_scope.match_value("calendar_item.name",params[:name])
    calendar_items,count = paginate(calendar_items_scope)
    respond_to do |format|
      format.html  {
        @datas = calendar_items
        @count = count
      }
      format.json {render :json=>to_jsonp(calendar_items.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end
end
