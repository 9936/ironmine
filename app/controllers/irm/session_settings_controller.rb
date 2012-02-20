class Irm::SessionSettingsController < ApplicationController
  # GET /session_settings
  # GET /session_settings.xml
  def index
    @session_timeout = Irm::SessionSetting.all.first
    if @session_timeout.nil?
      @session_timeout = Irm::SessionSetting.create()
    end
  end

  # PUT /session_settings/1
  # PUT /session_settings/1.xml
  def update
    @session_setting = Irm::SessionSetting.find(params[:id])

    respond_to do |format|
      if @session_setting.update_attributes(params[:irm_session_setting])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @session_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  #给予用户提示会话超时
  def timeout_warn
      render :layout => false
  end
end
