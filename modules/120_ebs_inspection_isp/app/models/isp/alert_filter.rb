class Isp::AlertFilter < ActiveRecord::Base
  set_table_name :isp_alert_filters

  validates_presence_of :check_item_id, :result_type, :operation, :value

  belongs_to :check_item, :foreign_key => :check_item_id

  scope :with_check_item, lambda {|check_item_id|
    self.where("#{table_name}.check_item_id=?", check_item_id)
  }

  scope :with_operation_meaning, lambda {
    joins("JOIN #{Irm::LookupValue.view_name} lpv ON lpv.lookup_code = #{table_name}.operation").
        where("lpv.language=?", I18n.locale).select("#{table_name}.*, lpv.meaning operation_name")
  }
end
