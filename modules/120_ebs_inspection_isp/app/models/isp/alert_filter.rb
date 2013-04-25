class Isp::AlertFilter < ActiveRecord::Base
  set_table_name :isp_alert_filters

  validates_presence_of :check_item_id, :result_type, :operation, :value, :display_template
  validates_format_of :value, :with => /^\d+\.\d+$|^\d+$/i, :if => Proc.new { |i| i.result_type == 'NUMBER' }

  belongs_to :check_item, :foreign_key => :check_item_id

  attr_accessor_with_default :content_format,"markdown"

  scope :with_check_item, lambda {|check_item_id|
    self.where("#{table_name}.check_item_id=?", check_item_id)
  }

  scope :with_operation_meaning, lambda {
    joins("JOIN #{Irm::LookupValue.view_name} lpv ON lpv.lookup_code = #{table_name}.operation").
        where("lpv.language=? AND lpv.lookup_type=?", I18n.locale, 'RULE_FILTER_OPERATOR').select("#{table_name}.*, lpv.meaning operation_name")
  }

  def check_result(symbol, target)
    c_str, r_str = compare_str(target)
    if eval(c_str)
      generate_alert({symbol.to_s => r_str})
    else
      ""
    end
  end

  def generate_alert(alert_result)
    display_template =Liquid::Template.parse self.display_template
    str = display_template.render alert_result.stringify_keys

    preview = Ironmine::WIKI.preview_page("Alert Filter", str, self.content_format)
    preview.formatted_data.force_encoding("utf-8")
  end

  private
    def compare_str(target)
      case self.operation
        when "E"
          return ["#{target} == #{self.value} || #{target}.eql?(#{self.value})", I18n.t(:label_isp_alert_filter_result, :target => target, :operation => I18n.t(:label_isp_alert_filter_e), :value => self.value )]
        when "G"
          return ["#{target} > #{self.value}", I18n.t(:label_isp_alert_filter_result, :target => target, :operation => I18n.t(:label_isp_alert_filter_g), :value => self.value )]
        when "L"
          return ["#{target} < #{self.value}", I18n.t(:label_isp_alert_filter_result, :target => target, :operation => I18n.t(:label_isp_alert_filter_l), :value => self.value )]
        when "N"
          return ["!#{target}.eql?(#{self.value})", I18n.t(:label_isp_alert_filter_result, :target => target, :operation => I18n.t(:label_isp_alert_filter_n), :value => self.value )]
        else
          return ["", ""]
      end
    end
end
