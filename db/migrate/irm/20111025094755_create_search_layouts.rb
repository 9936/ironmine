class CreateSearchLayouts < ActiveRecord::Migration
  def change
    create_table "irm_search_layouts", :force => true do |t|
      t.string   "opu_id",      :limit => 22
      t.string   "business_object_id",     :limit => 22,                        :null => false
      t.string   "code",     :limit => 30,                        :null => false
      t.string   "status_code",    :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",     :limit => 22,                        :null => false
      t.string   "updated_by",     :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_search_layouts, "id", :string,:limit=>22, :collate=>"utf8_bin"


    create_table "irm_search_layout_columns", :force => true do |t|
      t.string   "opu_id",      :limit => 22
      t.string   "search_layout_id", :limit => 22,                        :null => false
      t.string   "object_attribute_id",         :limit => 22,                        :null => false
      t.integer  "seq_num",                                             :null => false
      t.string   "status_code",    :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",     :limit => 22,                        :null => false
      t.string   "updated_by",     :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_search_layout_columns, "id", :string,:limit=>22, :collate=>"utf8_bin"

  end
end
