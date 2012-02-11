class Irm::SessionTimesController < ApplicationController
  # GET /session_times
  # GET /session_times.xml
  def index
    @session_time = Irm::SessionTime.all.first
    if @session_time.nil?
      @session_time = Irm::SessionTime.create()
    end
  end

  # PUT /session_times/1
  # PUT /session_times/1.xml
  def update
    @session_time = Irm::SessionTime.find(params[:id])

    respond_to do |format|
      if @session_time.update_attributes(params[:session_time])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @session_time.errors, :status => :unprocessable_entity }
      end
    end
  end
end
