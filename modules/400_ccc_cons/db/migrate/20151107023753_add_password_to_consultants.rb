class AddPasswordToConsultants < ActiveRecord::Migration
  def change
    add_column :cons_consultants, :password, :string
  end
end
