class ChangeClassMenuOrder < ActiveRecord::Migration
  def up
    menu_id = Irm::Menu.where(:code=>'CONFIG_MANAGEMENT').first.id
    function_id = Irm::FunctionGroup.where(:code=>"CONFIG_CLASS").first.id
    menu_entry = Irm::MenuEntry.where(:menu_id => menu_id).where(:sub_function_group_id => function_id).first
    menu_entry.update_attribute(:display_sequence, 10)
  end

  def down
  end
end
