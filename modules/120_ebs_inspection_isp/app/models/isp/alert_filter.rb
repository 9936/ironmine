class Isp::AlertFilter < ActiveRecord::Base
  set_table_name :isp_alert_filters

  validates_presence_of :check_item_id, :result_type, :operation, :value
  validates_format_of :value, :with => /^\d+\.\d+$|^\d+$/i, :if => Proc.new { |i| i.result_type == 'NUMBER' }

  belongs_to :check_item, :foreign_key => :check_item_id

  scope :with_check_item, lambda {|check_item_id|
    self.where("#{table_name}.check_item_id=?", check_item_id)
  }

  scope :with_operation_meaning, lambda {
    joins("JOIN #{Irm::LookupValue.view_name} lpv ON lpv.lookup_code = #{table_name}.operation").
        where("lpv.language=? AND lpv.lookup_type=?", I18n.locale, 'RULE_FILTER_OPERATOR').select("#{table_name}.*, lpv.meaning operation_name")
  }
end
