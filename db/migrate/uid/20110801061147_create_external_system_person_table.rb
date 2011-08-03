class CreateExternalSystemPersonTable < ActiveRecord::Migration
  def self.up
    create_table :uid_external_system_people, :force => true do |t|
      t.string :id, :limit => 22
      t.string :company_id, :limit => 22
      t.string :external_system_code, :limit => 30
      t.string :person_id, :limit => 30
      t.string   "status_code", :limit => 30, :default=>"ENABLED"
      t.string  "created_by"
      t.string  "updated_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def self.down
    drop_table :uid_external_system_people
  end
end
