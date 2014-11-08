class FixMamScPartyName < ActiveRecord::Migration
  def up
    rename_column :mam_master_scs, :party_name, :party_name_e
    add_column :mam_master_scs, :party_name_l, :string, :limit => 360, :after => :party_name_e
  end

  def down
  end
end
