class Cons::Product < ActiveRecord::Base
  set_table_name :cons_products
  # has_and_belongs_to_many :customers

  query_extend
  acts_as_customizable

  validates_presence_of :pro_name,:pro_customer_no,:pro_customer_contact,:pro_manager,:pro_type,:pro_pricing_type


  scope :with_product_message,lambda{}
end
