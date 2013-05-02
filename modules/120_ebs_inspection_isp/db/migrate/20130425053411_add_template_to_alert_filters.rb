class AddTemplateToAlertFilters < ActiveRecord::Migration
  def change
    add_column :isp_alert_filters, :display_template, :text, :after => :value
  end
end
