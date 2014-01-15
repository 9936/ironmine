class AddFirstCommunicateAt < ActiveRecord::Migration
  def change
    add_column :som_sales_opportunities,:first_communicate_at,:date,:after=>:open_at
  end
end
