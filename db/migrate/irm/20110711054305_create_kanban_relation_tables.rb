class CreateKanbanRelationTables < ActiveRecord::Migration
  def self.up
    create_table :irm_kanban_lanes, :force => true do |t|
      t.integer :kanban_id
      t.integer :lane_id
      t.string :status_code, :limit =>30, :null => false, :default => "ENABLED"
      t.integer :created_by
      t.integer :updated_by
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :irm_lane_cards, :force => true do |t|
      t.integer :lane_id
      t.integer :card_id
      t.string :status_code, :limit =>30, :null => false, :default => "ENABLED"
      t.integer :created_by
      t.integer :updated_by
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :irm_kanban_lanes
    drop_table :irm_lane_cards
  end
end
