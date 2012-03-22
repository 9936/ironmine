class ChangeConfigItemAttributesId < ActiveRecord::Migration
  def up
    change_column :com_config_item_attributes, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end

  def down
  end
end
