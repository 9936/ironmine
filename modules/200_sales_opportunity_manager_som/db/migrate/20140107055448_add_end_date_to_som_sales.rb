class AddEndDateToSomSales < ActiveRecord::Migration
  def change
    add_column :som_sales_opportunities ,:price_year,:string ,:after=>:progress
    add_column :som_sales_opportunities ,:second_price,:integer ,:after=>:price
    add_column :som_sales_opportunities ,:second_price_year ,:string  ,:after=>:price
    add_column :som_sales_opportunities ,:failed_reason ,:text  ,:after=>:end_at
  end
end
