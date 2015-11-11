class CreateConsCustomers < ActiveRecord::Migration
  def change
    create_table :cons_customers do |t|
      t.string :customer_name # 姓名
      t.string :customer_sex # 性别
      t.string :customer_duty # 职责
      t.string :customer_status # 客户状态
      t.string :customer_tel # 手机
      t.string :customer_telNo # 固定电话
      t.string :customer_email # 邮箱
      t.string :customer_fax # 传真
      t.string :customer_comment # 备注信息
      t.string :customer_flag # 删除标记
      t.string :customer_password #密码

      t.references :company, index: true

      t.timestamps
    end
  end
end
