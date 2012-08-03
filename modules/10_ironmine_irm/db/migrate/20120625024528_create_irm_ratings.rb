class CreateIrmRatings < ActiveRecord::Migration
  def change

    create_table :irm_ratings do |t|
      t.string   "opu_id",            :limit => 22 , :collate=>"utf8_bin"
      t.string   "rating_object_id",  :limit => 22 , :collate=>"utf8_bin"
      t.string   "bo_name",           :limit => 30 , :null => false
      t.string   "person_id",         :limit => 22 , :collate=>"utf8_bin"
      t.string   "grade",             :limit => 10, :default => "1",:null => false
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_ratings, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end
end
