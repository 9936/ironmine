class Dem::Project< ActiveRecord::Base
  set_table_name 'dem_projects'
  has_many :dev_managements, :dependent => :destroy
  #加入activerecord的通用方法和scope
  query_extend
end
