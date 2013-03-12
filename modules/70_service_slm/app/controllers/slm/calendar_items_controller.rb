class Slm::CalendarItemsController < ApplicationController
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


  def remove
    @calendar_item = Slm::CalendarItem.find(params[:id])

    @calendar_item.destroy

    respond_to do |format|
      format.json {render :json=> {:success => true}}
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
end
