class CreateConsProducts < ActiveRecord::Migration
  def change
    create_table :cons_products do |t|
      t.string :pro_name # 项目名称
      t.string :pro_customer_no # 客户编号
      t.string :pro_customer_contact # 客户项目关键联系人
      t.string :pro_manager # 项目经理
      t.string :pro_type # 项目类型
      t.string :pro_pricing_type # 计价方式
      t.date :pro_begin_date # 项目开始时间
      t.date :pro_end_date # 项目结束时间
      t.string :pro_disabled_flag # 服务失效标识
      t.text :pro_comment # 备注信息
      t.float :pro_remote_date # 远程人天
      t.float :pro_scene_date # 现场人天
      t.date :pro_respond_time # 响应时间
      t.date :pro_handle_time # 开始处理时间
      t.date :pro_update_time# 更新时间
      t.date :pro_total_time # 总处理时间
      t.date :pro_max_time # 最大处理问题时间
      t.float :pro_remind_rate # 即将超出时间提醒(比例)
      t.float :pro_warning_rate # 超出时间时间警告
      t.string :pro_show_to_SLA_flag # SLA是否显示给客户
      t.string :pro_group # 对应组别

      t.timestamps
    end
  end
end
