class DropProfileLaneTable < ActiveRecord::Migration
  def self.up
    drop_table :irm_profile_lanes
  end

  def self.down
    create_table :irm_profile_lanes, :force => true do |t|
      t.string :company_id, :limit => 22, :null=> false
      t.string :profile_id, :limit => 22, :null=> false
      t.string :kanban_id, :limit => 22, :null=> false
      t.string :lane_id, :limit => 22, :null=> false
      t.integer :display_sequence
      t.string :status_code, :limit => 30,:null => false,:default=>"ENABLED"
      t.string :created_by,:limit=>22,:null=>false
      t.string :updated_by,:limit=>22,:null=>false
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
