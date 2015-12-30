class UpdateExternalSystem < ActiveRecord::Migration
  def up
    remove_column :irm_external_systems, :respond_time #响应时间
    remove_column :irm_external_systems, :handle_time #开始处理时间
    remove_column :irm_external_systems, :update_time #更新时间
    remove_column :irm_external_systems, :total_time #总处理时间
    remove_column :irm_external_systems, :max_time #最大处理问题时间
    remove_column :irm_external_systems, :remind_rate #即将超出时间提醒(比例)
    remove_column :irm_external_systems, :warning_rate #超出时间警告(比例)
    remove_column :irm_external_systems, :show_SLA_flag  #SLA是否显示给客户
    add_column :irm_external_systems, :people_date_message, :string #记录人天信息
  end

  def down
  end
end
