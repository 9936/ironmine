class Irm::Permission < ActiveRecord::Base
  set_table_name :irm_permissions

  
  belongs_to :function

  attr_accessor :function_code


  # 验证权限编码唯一性
  validates_presence_of :code,:controller,:action,:function_id,:product_id

  #加入activerecord的通用方法和scope
  query_extend

  before_validation :setup_parent

  scope :query_by_function_code,lambda{|function_code|
    joins("JOIN #{Irm::Function.table_name} ON #{table_name}.function_id = #{Irm::Function.table_name}.id").
    where("#{Irm::Function.table_name}.code = ?",function_code)
  }

  scope :query_by_function_group,lambda{|function_group_id|
    joins("JOIN #{Irm::Function.table_name} ON #{table_name}.function_id = #{Irm::Function.table_name}.id").
    where("#{Irm::Function.table_name}.function_group_id = ?",function_group_id)
  }


  def setup_parent
    product_code = self.controller.gsub(/\/.*/, "")
    product = Irm::ProductModule.query_by_short_name(product_code.upcase).first
    self.product_id = product.id if product
    if self.function_id.nil?&&self.function_code.present?
      code_function =  Irm::Function.where(:code=>self.function_code).first
      if(code_function)
        self.function_id = code_function.id
      end
    end

  end

  def self.list_all
    self.select_all
  end

  def self.url_key(controller,action)
    "#{controller.gsub(/\//, "_")}_#{action}"
  end

  def self.page_help_url(controller,action)
    "#{controller.gsub(/.*\//, "")}_#{action}"
  end



  def self.to_permission(options={})
    crop(options)
    Irm::Permission.new(options)
  end

end
