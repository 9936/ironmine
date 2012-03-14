class CreateConfigRelationTypes < ActiveRecord::Migration
  def change
    create_table :com_config_relation_types do |t|
      t.string   "opu_id",      :limit => 22 , :collate=>"utf8_bin"
      t.string   "code",   :limit => 30,:null => false
      t.string   "status_code",   :limit => 30, :default => "ENABLED",:null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :com_config_relation_types, "id", :string,:limit=>22, :collate=>"utf8_bin"

    create_table :com_config_relation_types_tl do |t|
      t.string   "opu_id",      :limit => 22 , :collate=>"utf8_bin"
      t.string   "config_relation_type_id",      :limit => 22 , :collate=>"utf8_bin"
      t.string   "language",         :limit => 30,  :null => false
      t.string   "name",             :limit => 150
      t.string   "description",      :limit => 240
      t.string   "source_lang",      :limit => 30,  :null => false
      t.string   "status_code",   :limit => 30, :default => "ENABLED",:null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :com_config_relation_types_tl, "id", :string,:limit=>22, :collate=>"utf8_bin"
    execute('CREATE OR REPLACE VIEW com_config_relation_types_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                             FROM com_config_relation_types t,com_config_relation_types_tl tl
                             WHERE t.id = tl.config_relation_type_id')
  end
end
