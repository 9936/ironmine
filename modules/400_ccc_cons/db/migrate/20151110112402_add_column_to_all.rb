class AddColumnToAll < ActiveRecord::Migration
  def change
    add_column :cons_companies, :company_no, :string
    add_column :cons_products, :product_no, :string
    add_column :cons_consultants, :consultants_no, :string
  end
end
