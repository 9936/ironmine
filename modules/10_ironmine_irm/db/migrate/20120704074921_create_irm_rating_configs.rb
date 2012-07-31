class CreateIrmRatingConfigs < ActiveRecord::Migration
  def change
    create_table :irm_rating_configs do |t|
      t.string   "opu_id",            :limit => 22 , :collate=>"utf8_bin"
      t.string   "code",              :limit => 30
      t.string   "name",              :limit => 150
      t.string   "description",       :limit => 240
      t.string   "display_style" ,    :limit => 30
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_rating_configs, "id", :string,:limit=>22, :collate=>"utf8_bin"

    create_table :irm_rating_config_grades do |t|
      t.string   "opu_id",            :limit => 22 , :collate=>"utf8_bin"
      t.string   "rating_config_id",  :limit => 22, :collate=>"utf8_bin"
      t.integer  "grade"
      t.string   "name",              :limit => 150
      t.string   "description",       :limit => 240
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_rating_config_grades, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end
end