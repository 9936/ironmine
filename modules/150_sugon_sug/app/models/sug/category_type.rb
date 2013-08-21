class Sug::CategoryType < ActiveRecord::Base
  set_table_name :sug_category_types

  has_many :category_values, :foreign_key => :category_type_id, :dependent => :destroy

end
