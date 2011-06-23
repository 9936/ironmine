class AlterLoginRecordId < ActiveRecord::Migration
  def self.up
    change_column :irm_login_records, :id, :string,:limit=>24, :null => false
  end

  def self.down
    change_column :irm_login_records, :id, :integer, :null => false
  end
end
