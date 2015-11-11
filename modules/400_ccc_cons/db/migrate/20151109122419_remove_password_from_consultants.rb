class RemovePasswordFromConsultants < ActiveRecord::Migration
  def up
    remove_column :cons_consultants, :password
  end

  def down
  end
end
