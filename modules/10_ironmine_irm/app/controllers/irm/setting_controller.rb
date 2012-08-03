class Irm::SettingController < ApplicationController
  def index

  end

  def common
    self.class.layout "setting"
    @menu_entry = Irm::MenuEntry.multilingual.find(params[:mi])
    if @menu_entry.sub_menu_id.present?
      @setting_menus = Irm::MenuManager.parent_menus_by_menu(@menu_entry.sub_menu_id)+[@menu_entry.sub_menu_id]
    end
  end
end
