class AddInterfaceFlagToMasterItem < ActiveRecord::Migration
  def change
    add_column :mam_master_items, :interface_flag, :string
  end
end
