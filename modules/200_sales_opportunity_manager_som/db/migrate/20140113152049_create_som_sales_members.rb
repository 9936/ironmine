class CreateSomSalesMembers < ActiveRecord::Migration
  def change
    add_column :som_sales_opportunities, :internal_member,:string,:limit => 300,:after=>:end_at
    add_column :som_sales_opportunities, :external_member,:string,:limit => 300,:after=>:end_at
    add_column :som_sales_opportunities ,:open_at,:date ,:after=>:end_at
    change_column :som_sales_opportunities,:possibility,:integer,:default=>0
  end
end
