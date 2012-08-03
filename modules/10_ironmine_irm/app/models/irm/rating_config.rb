class Irm::RatingConfig < ActiveRecord::Base
  set_table_name :irm_rating_configs
  #加入activerecord的通用方法和scope
  query_extend
  #对运维中心数据进行隔离
  default_scope {default_filter}


  validates_presence_of :name,:code
  validates_format_of :code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| i.code.present?},:message=>:code
  
  
  has_many :rating_config_grades
  accepts_nested_attributes_for :rating_config_grades


  def self.new_for_edit(options={})
    rating_config = self.new(options)
    0.upto 9 do |index|
      rating_config.rating_config_grades.build({:grade=>index+1})
    end
    rating_config
  end

end