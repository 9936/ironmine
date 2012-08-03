class CreateConfigClasses < ActiveRecord::Migration
  def up
    #create table
    create_table "com_config_classes", :force => true do |t|
      t.string   "opu_id",        :limit => 22 , :collate=>"utf8_bin"
      t.string   "code",          :limit => 60, :null => false
      t.string   "leaf_flag",  :limit => 1, :null => false,:default=>"N"
      t.string   "status_code",      :limit => 30, :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :com_config_classes, "id", :string,:limit=>22, :collate=>"utf8_bin"
    add_index "com_config_classes", ["code"], :name => "COM_CONFIG_CLASS_N1"

    create_table "com_config_classes_tl", :force => true do |t|
      t.string   "opu_id",           :limit => 22 , :collate=>"utf8_bin"
      t.string   "config_class_id",      :limit => 22, :collate=>"utf8_bin"
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

    change_column :com_config_classes_tl, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "com_config_classes_tl", ["config_class_id", "language"], :name => "COM_CONFIG_CLASS_TL_U1", :unique => true
    add_index "com_config_classes_tl", ["config_class_id"],             :name => "COM_CONFIG_CLASS_TL_N1"

    execute('CREATE OR REPLACE VIEW com_config_classes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                         FROM com_config_classes t,com_config_classes_tl tl
                         WHERE t.id = tl.config_class_id')
  end

  def down
    drop_table :com_config_classes
    drop_table :com_config_classes_tl
    execute('DROP VIEW com_config_classes_vl')
  end
end
