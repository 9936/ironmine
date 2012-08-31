class AddDevelopMenuToAppSetting < ActiveRecord::Migration
  def change
    menu_entiry_120= Irm::MenuEntry.new(:menu_code=>'APPLICATION_SETTING',:sub_menu_code=>'DEVELOPMENT',:sub_function_group_code=>nil,:display_sequence=>30)
    menu_entiry_120.save

  end
end
