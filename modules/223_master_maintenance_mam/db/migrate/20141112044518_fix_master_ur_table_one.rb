class FixMasterUrTableOne < ActiveRecord::Migration
  def up
    change_column :mam_master_urs, :master_id, :string, :limit => 22
  end

  def down
  end
end
