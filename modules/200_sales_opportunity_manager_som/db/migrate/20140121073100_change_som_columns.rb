class ChangeSomColumns < ActiveRecord::Migration
  def change
    change_column :som_potential_customers, :website,:text
    change_column :som_sales_opportunities, :price, :float
    change_column :som_sales_opportunities, :total_price, :float
    change_column :som_sales_opportunities, :second_price, :float
  end
end
