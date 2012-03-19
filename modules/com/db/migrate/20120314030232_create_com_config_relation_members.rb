class CreateComConfigRelationMembers < ActiveRecord::Migration
  def change
    create_table :com_config_relation_members do |t|
        t.string   "opu_id",      :limit => 22 , :collate=>"utf8_bin"
        t.string   "config_relation_type_id",   :limit => 22 , :collate=>"utf8_bin"
        t.string   "config_class_id",   :limit => 22 , :collate=>"utf8_bin"
        t.string   "status_code",   :limit => 30, :default => "ENABLED",:null => false
        t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
        t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
        t.datetime "created_at"
        t.datetime "updated_at"
    end
    change_column :com_config_relation_members, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end
end
