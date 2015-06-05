class CreateParentPeopleTable < ActiveRecord::Migration
  def up
    create_table :yan_parent_people do |t|
      t.string   "opu_id",         :limit => 22
      t.string   "person_id",    :limit => 22, :collate=>"utf8_bin"
      t.string   "parent_person_id",    :limit => 22, :collate=>"utf8_bin"
      t.string   "status_code",    :limit => 30
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :yan_parent_people, "id", :string, :limit => 22, :collate => "utf8_bin"
  end

  def down
  end
end
