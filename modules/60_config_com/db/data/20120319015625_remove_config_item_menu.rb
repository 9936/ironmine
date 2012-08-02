class RemoveConfigItemMenu < ActiveRecord::Migration
  def up
    menu_id=Irm::Menu.find_by_code("CONFIG_MANAGEMENT").id
    funcition_group_id=Irm::FunctionGroup.find_by_code('CONFIG_ITEM').id

    menu_entiry_127= Irm::MenuEntry.where(:menu_id=>menu_id,:sub_function_group_id=> funcition_group_id,:display_sequence=>40).delete_all

  end

  def down
  end
end
