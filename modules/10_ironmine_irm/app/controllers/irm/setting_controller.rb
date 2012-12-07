class Irm::SettingController < ApplicationController
  def index

  end

  def common
    self.class.layout "setting"
    @menu_entry = Irm::MenuEntry.multilingual.find(params[:mi])
    if @menu_entry.sub_menu_id.present?
      @setting_menus = Irm::MenuManager.parent_menus_by_menu(@menu_entry.sub_menu_id)+[@menu_entry.sub_menu_id]
    end
    #判断当前是否有sid参数
    if params[:sid].present? and params[:sid].length == 22
      system = Irm::ExternalSystem.multilingual.enabled.find(params[:sid])
      if system
        Irm::ExternalSystem.current_system = system
        session[:sid] = system.id
      end
    end
  end
end
