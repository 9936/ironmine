class AddPeopleTmpTable < ActiveRecord::Migration
  def up
    create_table :cpi_people_tmp, :force => true do |t|
      t.string   "organization", :limit => 100
      t.string   "name", :limit => 100
      t.string   "tel", :limit => 100
      t.string   "mobile",    :limit => 100
      t.string   "mail",    :limit => 100
      t.string   "group",    :limit => 100
      t.string   "login_name",    :limit => 100
      t.string   "status",    :limit => 200
      t.datetime "updated_at"
    end
  end

  def down
  end
end
