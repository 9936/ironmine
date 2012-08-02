class CreateConfigAttributes < ActiveRecord::Migration
  def up
    #create table
    create_table "com_config_attributes", :force => true do |t|
      t.string   "opu_id",        :limit => 22 , :collate=>"utf8_bin"
      t.string   "code",          :limit => 60, :null => false
      t.string   "config_class_id", :limit => 22, :collate=>"utf8_bin"
      t.string   "input_type",       :limit => 30
      t.string   "status_code",      :limit => 30, :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :com_config_attributes, "id", :string,:limit=>22, :collate=>"utf8_bin"
    add_index "com_config_attributes", ["code"], :name => "COM_CONFIG_ATTRIBUTE_N1"

    create_table "com_config_attributes_tl", :force => true do |t|
      t.string   "opu_id",           :limit => 22 , :collate=>"utf8_bin"
      t.string   "config_attribute_id",      :limit => 22, :collate=>"utf8_bin"
      t.string   "language",         :limit => 30,  :null => false
      t.string   "name",             :limit => 150
      t.string   "description",      :limit => 240
      t.string   "source_lang",      :limit => 30,  :null => false
      t.string   "status_code",      :limit => 30, :null => false
      t.string   "created_by",       :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",       :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :com_config_attributes_tl, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "com_config_attributes_tl", ["config_attribute_id", "language"], :name => "COM_CONFIG_ATTRIBUTE_TL_U1", :unique => true
    add_index "com_config_attributes_tl", ["config_attribute_id"],             :name => "COM_CONFIG_ATTRIBUTE_TL_N1"

    execute('CREATE OR REPLACE VIEW com_config_attributes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                         FROM com_config_attributes t,com_config_attributes_tl tl
                         WHERE t.id = tl.config_attribute_id')
  end

  def down
    drop_table :com_config_attributes
    drop_table :com_config_attributes_tl
    execute('DROP VIEW com_config_attributes_vl')
  end
end
