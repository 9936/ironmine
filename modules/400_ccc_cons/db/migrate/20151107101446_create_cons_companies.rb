class CreateConsCompanies < ActiveRecord::Migration
  def change
    create_table :cons_companies do |t|
      t.string :com_name # 客户名称
      t.string :com_address # 客户地址
      t.integer :com_ZCode # 客户邮编
      t.string :com_city # 客户城市
      t.string :com_province # 客户省份
      t.string :com_country # 客户国家
      # 负责人信息
      t.string :com_conscientious # 客户负责人
      t.string :com_position # 负责人职位
      t.string :com_conscientious_tel # 客户负责人手机
      t.string :com_conscientious_telNo # 客户负责人座机
      t.string :com_conscientious_email # 客户负责人邮箱
      # 运维信息
      t.string :com_A1_flag # 是否A1客户
      t.string :com_sale # 销售
      t.string :com_industry # 所属行业
      t.date :com_service_data # 最早运维服务日期
      t.text :com_attention_point # 运维关键注意点
      # 客户登录信息
      t.string :com_connect_type # 连接类型
      t.string :com_router # SAProuter
      t.text :com_dev_mess # ECC开发机登录信息
      t.text :com_test_mess # ECC测试机登录信息
      t.text :com_prod_mess # ECC生产机登录信息
      t.text :com_sys_mess # 其它SAP系统登录信息


      t.timestamps
    end
  end
end
