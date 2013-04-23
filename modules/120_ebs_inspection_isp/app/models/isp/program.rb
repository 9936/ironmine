class Isp::Program < ActiveRecord::Base
  set_table_name :isp_programs

  #多语言关系
  attr_accessor :name,:description
  has_many :programs_tls, :dependent => :destroy
  has_many :connections, :foreign_key => :program_id, :dependent => :destroy
  has_many :check_parameters, :foreign_key => :program_id, :dependent => :destroy
  has_many :check_items, :foreign_key => :program_id, :dependent => :destroy
  has_many :check_templates, :foreign_key => :program_id, :dependent => :destroy
  has_many :program_triggers, :foreign_key => :program_id, :dependent => :destroy

  acts_as_multilingual
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  attr_accessor :execute_context


  accepts_nested_attributes_for :connections,:check_parameters


  def execute(execute_context={})
    self.check_items.each do |check_item|
      #依次执行
      execute_context.merge!(check_item.object_symbol=>check_item.execute(execute_context))
    end
    execute_context
  end

  def params
    input_params = []
    self.connections.each do |con|
      input_params << con
    end
    self.check_parameters.each do |param|
      input_params << param
    end
  end


  def generate_report(context)
    str = ""

    self.check_templates.each do  |ct|
      str << ct.generate_html(context)
    end
    str
  end

end
