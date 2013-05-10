class Isp::Program < ActiveRecord::Base
  set_table_name :isp_programs

  #多语言关系
  attr_accessor :name,:description
  has_many :programs_tls, :dependent => :destroy
  has_many :connections, :foreign_key => :program_id, :dependent => :destroy

  #has_many :check_items, :foreign_key => :program_id, :dependent => :destroy
  has_many :check_templates, :foreign_key => :program_id, :dependent => :destroy
  has_many :program_triggers, :foreign_key => :program_id, :dependent => :destroy

  acts_as_multilingual
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  attr_accessor :execute_context


  accepts_nested_attributes_for :connections


  def execute(execute_context={})
    self.connections.each do |conn|
      conn.hand_host
      execute_context[conn.object_symbol] ||= {}
      execute_context[conn.object_symbol].merge!(conn.execute(execute_context))
    end

    execute_context
  end

  def params
    input_params = []
    self.connections.each do |con|
      input_params << con
    end
    #self.check_parameters.each do |param|
    #  input_params << param
    #end
  end


  def generate_report(context)
    str = ""

    self.check_templates.each do  |ct|
      str << ct.generate_html(context)
    end
    str
  end


  #检查警告
  def check_alert(results)
    alert_results = ""
    #遍历连接中的巡检项目
    self.connections.each do |conn|
      conn.check_items.each do |check_item|
        alert_filters = check_item.alert_filters
        if alert_filters.any?
          #巡检的结果中有对应的值
          check_item_result = results[conn.object_symbol.to_s][check_item.object_symbol.to_s]

          if check_item_result.present?
            #去除换行
            check_item_result = check_item_result.gsub(/\n/," ")
            alert_filters.each do |alert_filter|
              begin
                alert_check_result = alert_filter.check_result(check_item.object_symbol, check_item_result)
              rescue
                alert_check_result = ""
              end

              if alert_check_result.present?
                alert_results << alert_check_result
              end
            end
          end
        end
      end
    end

    alert_results
  end

end
