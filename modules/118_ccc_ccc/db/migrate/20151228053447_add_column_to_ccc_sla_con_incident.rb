class AddColumnToCccSlaConIncident < ActiveRecord::Migration
  def change
    # add_column :ccc_sla_con_incidents, :service_name, :string #服务协议名称
    # add_column :ccc_sla_con_incidents, :type_name, :string    #sla触发类型(警告/超时)
  end
end
