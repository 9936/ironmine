class CreateConsConsultants < ActiveRecord::Migration
  def change
    create_table :cons_consultants do |t|
      t.string :cNo  # 工号
      t.string :cName # 姓名
      t.string :cType # 顾问类型
      t.string :cSex # 性别
      t.string :cTel # 手机
      t.string :cTelNo # 固定电话
      t.string :cMail # 邮箱
      t.string :cFax # 传真
      t.text :cComment # 备注信息
      t.string :cFlag # 删除标记
      t.string :cModule # 模块
      t.string :cStatus # 状态
      t.string :cGroup # 组别
      t.string :cLevel # Level
      t.string :cRole # 角色
      t.references :manager # 上一级顾问的工号

      t.timestamps
    end
  end
end
