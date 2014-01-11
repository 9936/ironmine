class AddTotalPriceToSomSales < ActiveRecord::Migration
  def change
    add_column :som_sales_opportunities ,:total_price,:integer ,:after=>:progress
  end
end
