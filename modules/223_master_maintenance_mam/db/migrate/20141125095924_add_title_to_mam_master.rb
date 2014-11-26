class AddTitleToMamMaster < ActiveRecord::Migration
  def change
    add_column :mam_masters, :title, :string, :limit => 240, :after => :master_number
  end
end
