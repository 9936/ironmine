class CreateOrganizationInfos < ActiveRecord::Migration
  def change
    #create table
    create_table "irm_organization_infos", :force => true do |t|
      t.string   "opu_id",        :limit => 22 , :collate=>"utf8_bin"
      t.string   "name",          :limit => 60, :null => false
      t.string   "value",         :limit => 50, :null => false
      t.string   "description",   :limit => 40, :null => false
      t.string   "attachment_id", :limit => 22, :collate=>"utf8_bin"
      t.string   "status_code",   :limit => 30, :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_organization_infos, "id", :string,:limit=>22, :collate=>"utf8_bin"
    add_index :irm_organization_infos, :name
    add_index :irm_organization_infos, :value
  end

  #delete table
  def down
    drop_table :irm_organization_infos
  end
end
