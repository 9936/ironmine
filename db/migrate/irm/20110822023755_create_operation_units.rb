class CreateOperationUnits < ActiveRecord::Migration
  def self.up

    create_table "irm_operation_units", :force => true do |t|
      t.string  "short_name",             :limit => 30
      t.string  "primary_person_id",      :limit => 22
      t.string  "default_language_code",  :limit => 22
      t.string  "default_time_zone_code", :limit => 30
      t.string  "opu_id", :limit => 22
      t.string   "status_code",           :limit => 30, :default=>"ENABLED"
      t.integer  "created_by"
      t.integer  "updated_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :irm_operation_units, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"

    create_table "irm_operation_units_tl", :force => true do |t|
      t.string    "operation_unit_id",:limit => 22,:null => false
      t.string    "name",          :limit=>30,:null=>false
      t.string    "description",   :limit=>150
      t.string    "language",      :limit=>30
      t.string    "source_lang",   :limit=>30
      t.string    "opu_id", :limit => 22
      t.string    "status_code",   :limit => 30, :default=>"ENABLED"
      t.integer   "created_by"
      t.integer   "updated_by"
      t.datetime  "created_at"
      t.datetime  "updated_at"
    end

    change_column :irm_operation_units_tl, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"

    add_index "irm_operation_units_tl", ["operation_unit_id", "language"], :name => "IRM_OPERATION_UNIT_TL_U1", :unique => true

    execute('CREATE OR REPLACE VIEW irm_operation_units_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM irm_operation_units t,irm_operation_units_tl tl
                                                 WHERE t.id = tl.operation_unit_id')
  end

  def self.down
    drop_table :irm_operation_units
    drop_table :irm_operation_units_tl
    execute('drop view irm_operation_units_vl')
  end
end
