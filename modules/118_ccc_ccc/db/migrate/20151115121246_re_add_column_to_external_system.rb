class ReAddColumnToExternalSystem < ActiveRecord::Migration
  def up
    # add_column :irm_external_systems, :project_manager, :string #项目经理
    # add_column :irm_external_systems, :begin_date, :datetime #项目开始时间
    # add_column :irm_external_systems, :after_date, :datetime #项目结束时间
    # add_column :irm_external_systems, :disabled_flag, :string #失效标识
    #
    # add_column :irm_external_systems, :remote_date, :integer #远程人天
    # add_column :irm_external_systems, :scene_date, :integer #现场人天
    #
    # add_column :irm_external_systems, :respond_time, :float #响应时间
    # add_column :irm_external_systems, :handle_time, :float #开始处理时间
    # add_column :irm_external_systems, :update_time, :float #更新时间
    # add_column :irm_external_systems, :total_time, :float #总处理时间
    # add_column :irm_external_systems, :max_time, :float #最大处理问题时间
    # add_column :irm_external_systems, :remind_rate, :integer #即将超出时间提醒(比例)
    # add_column :irm_external_systems, :warning_rate, :integer #超出时间警告(比例)
    # add_column :irm_external_systems, :show_SLA_flag, :integer  #SLA是否显示给客户
  end

  def down
  end
end
