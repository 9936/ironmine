class ChangeCustomers < ActiveRecord::Migration
  def change
    add_column :sug_customers, :nickname, :string, :after => :name
  end
end
