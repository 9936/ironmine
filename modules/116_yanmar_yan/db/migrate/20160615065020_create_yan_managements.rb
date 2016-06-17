class CreateYanManagements < ActiveRecord::Migration
  def change
    create_table :yan_managements do |t|
      t.string "management_code", :limit => 100, :null => false
      t.string "name", :limit => 100, :null => false
      t.string "description", :limit => 500, :null => false
      t.timestamps
    end
  end
end
