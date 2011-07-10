class CreateKanbanTables < ActiveRecord::Migration
  def self.up
    create_table :irm_kanbans, :force => true do |t|
      t.string :kanban_code, :limit => 30, :null => false
      t.integer :refresh_interval, :default => 5, :null => false
      t.string :status_code, :limit =>30, :null => false, :default => "ENABLED"
      t.integer :created_by
      t.integer :updated_by
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :irm_kanbans_tl, :force => true do |t|
      t.integer :kanban_id
      t.string :name, :limit => 150, :null => false
      t.string :description, :limit =>240
      t.string :status_code, :limit =>30, :null => false, :default => "ENABLED"
      t.integer :created_by
      t.integer :updated_by
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :irm_kanban_ranges, :force => true do |t|
      t.integer :kanban_id, :null => false
      t.string :range_type, :limit => 30, :null => false
      t.integer :range_id, :null => false
      t.string :status_code, :limit =>30, :null => false, :default => "ENABLED"
      t.integer :created_by
      t.integer :updated_by
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :irm_lanes, :force => true do |t|
      t.string :lane_code, :limit => 30, :null => false
      t.integer :limit, :null => false, :default => 0
      t.string :status_code, :limit =>30, :null => false, :default => "ENABLED"
      t.integer :created_by
      t.integer :updated_by
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :irm_lanes_tl, :force => true do |t|
      t.integer :lane_id
      t.string :name, :limit =>150, :null => false
      t.string :description, :limit => 240
      t.string :status_code, :limit =>30, :null => false, :default => "ENABLED"
      t.integer :created_by
      t.integer :updated_by
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :irm_cards, :force =>true do |t|
      t.string :card_code, :limit => 30, :null => false
      t.string :background_color, :limit => 30
      t.string :font_color, :limit => 30
      t.string :bo_code, :limit =>30
      t.integer :rule_filter_id
      t.string :system_flag, :limit => 1, :null => false, :default => "N"
      t.text :card_url
      t.integer :title_attribute_id
      t.integer :description_attribute_id
      t.integer :date_attribute_id
      t.string :status_code, :limit =>30, :null => false, :default => "ENABLED"
      t.integer :created_by
      t.integer :updated_by
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :irm_cards_tl, :force => true do |t|
      t.integer :card_id
      t.string :name, :limit => 150, :null => false
      t.string :description, :limit => 240
      t.string :status_code, :limit =>30, :null => false, :default => "ENABLED"
      t.integer :created_by
      t.integer :updated_by
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
  end
end
