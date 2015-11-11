class AddColumnToCustomer < ActiveRecord::Migration
  def change
    add_column :cons_customers, :customer_no, :string
  end
end
