class ReworkKanbanTables < ActiveRecord::Migration
  def self.up
    execute('DROP VIEW irm_kanbans_vl')
    execute('DROP VIEW irm_lanes_vl')

    add_column :irm_kanbans, :company_id, :string, :limit => 22, :after => :id
    add_column :irm_kanbans, :refresh_interval, :integer, :default => 5, :after => :company_id
    add_column :irm_kanbans, :limit, :integer, :default => 5, :after => :company_id
    add_column :irm_kanbans, :position_code, :string, :limit => 30

    create_table :irm_kanban_lanes, :force => true do |t|
      t.integer :kanban_id
      t.integer :lane_id
      t.integer :display_sequence, :null => false, :default => 1
      t.string :status_code, :limit =>30, :null => false, :default => "ENABLED"
      t.integer :created_by
      t.integer :updated_by
      t.datetime :created_at
      t.datetime :updated_at
    end

    execute('CREATE OR REPLACE VIEW irm_kanbans_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_kanbans  t,irm_kanbans_tl tl
                                           WHERE t.id = tl.kanban_id')
    execute('CREATE OR REPLACE VIEW irm_lanes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_lanes  t,irm_lanes_tl tl
                                           WHERE t.id = tl.lane_id')
  end

  def self.down
    execute('DROP VIEW irm_kanbans_vl')
    execute('DROP VIEW irm_lanes_vl')
    remove_column :irm_kanbans, :refresh_interval
    remove_column :irm_kanbans, :limit
    remove_column :irm_kanbans, :position_code
    drop_table :irm_kanban_lanes

    execute('CREATE OR REPLACE VIEW irm_lanes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_lanes  t,irm_lanes_tl tl
                                           WHERE t.id = tl.lane_id')
    execute('CREATE OR REPLACE VIEW irm_kanbans_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_kanbans  t,irm_kanbans_tl tl
                                           WHERE t.id = tl.kanban_id')
  end
end
