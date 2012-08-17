# 用于存放IRM模块对应的菜单页面
class Irm::NavigationsController < ApplicationController
    layout "navigations"
    skip_before_filter :check_permission,:menu_setup, :menu_entry_setup
  # 顶级菜单对应的菜单页面
  def index
    redirect_entrance
  end

  def change_application
    session[:application_id] = params[:application_id] if params[:application_id]
    Irm::Application.current= Irm::Application.enabled.find(session[:application_id])
    redirect_entrance
  end

  def access_deny
    respond_to do |format|
      format.html {render :layout=>"bootstrap_application_full"}
      format.xml  { render :status => :access_deny }
      format.js  { render :json=>{:status => :access_deny}.to_json }
      format.json  { render :json=>{:status => :access_deny}.to_json }
    end
  end

  def combo
    contents = ""
    params.keys.each do |k|
     next unless k.to_s.end_with?(".js")||k.to_s.end_with?(".css")
     contents << IO.read("#{Rails.root}/public#{k.to_s}")
    end
    render :text=> contents
  end

end
