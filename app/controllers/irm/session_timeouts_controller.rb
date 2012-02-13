class Irm::SessionTimeoutsController < ApplicationController
  # GET /session_timeouts
  # GET /session_timeouts.xml
  def index
    @session_timeout = Irm::SessionTimeout.all.first
    if @session_timeout.nil?
      @session_timeout = Irm::SessionTimeout.create()
    end
  end

  # PUT /session_timeouts/1
  # PUT /session_timeouts/1.xml
  def update
    @session_timeout = Irm::SessionTimeout.find(params[:id])

    respond_to do |format|
      if @session_timeout.update_attributes(params[:irm_session_timeout])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @session_timeout.errors, :status => :unprocessable_entity }
      end
    end
  end
end
