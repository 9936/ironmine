class CreateProfileKanbanTables < ActiveRecord::Migration
  def self.up
    create_table :irm_profile_kanbans, :force => true do |t|
      t.string :company_id, :limit => 22, :null => false
      t.string :profile_id, :limit => 22, :null => false
      t.string :kanban_id, :limit => 22, :null => false
      t.string :position_code, :limit => 30, :null => false
      t.integer :limit, :default => 5
      t.integer :refresh_interval, :default => 10
      t.string   :status_code, :limit => 30,  :null => false,:default=>"ENABLED"
      t.string   :created_by,:limit=>22,:null=>false
      t.string   :updated_by,:limit=>22,:null=>false
      t.datetime :created_at
      t.datetime :updated_at
    end

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

  def self.down
    drop_table :irm_profile_kanbans
    drop_table :irm_profile_lanes
  end
end
