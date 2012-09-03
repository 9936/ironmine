class ChangeMailRequestMenuPosition < ActiveRecord::Migration
  def up
    function_group = Irm::FunctionGroup.where("code = ?", "MAIL_REQUEST").first
    function_group.update_attribute(:zone_code, "INCIDENT_SETTING")
    function_group.save

    menu = Irm::Menu.where("code = ?", "INCIDENT_MANAGEMENT").first
    menu_entry = Irm::MenuEntry.where("sub_function_group_id = ?", function_group.id).first
    menu_entry.update_attribute(:menu_id, menu.id)
    menu_entry.update_attribute(:display_sequence, "100")
    menu_entry.save
  end

  def down
  end
end
