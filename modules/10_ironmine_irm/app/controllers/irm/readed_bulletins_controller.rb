class Irm::ReadedBulletinsController < ApplicationController
  layout "application_full"
  # GET /irm/readed_bulletins
  # GET /irm/readed_bulletins.xml
  def index
    @unreaded=Irm::ReadedBulletin.unread_bulletin

    @back_url=params[:back_url]
    #防止未读公告为空时，用户输入链接直接跳转
    if @unreaded.blank?
      redirect_back_or_default
      return
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @irm_readed_bulletins }
    end
  end

  def continue
    #将未读公告置为已读
    @readed=Irm::ReadedBulletin.unread_bulletin
    Irm::ReadedBulletin.set_readed(@readed)
    redirect_back_or_default
  end
end
