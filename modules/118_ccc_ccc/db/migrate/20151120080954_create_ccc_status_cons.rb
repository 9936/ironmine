class CreateCccStatusCons < ActiveRecord::Migration
  def change
    create_table :ccc_status_cons do |t|
      t.string   "external_system_id" # 项目id
      t.string   "incident_status_parent_id"  # 根节点状态
      t.string   "incident_status_children_id" # 子节点状态
      t.string   "profile_type_id" # 用户类型
      t.string   "attribute1"
      t.string   "attribute2"
      t.string   "attribute3"
      t.string   "attribute4"
      t.timestamps
    end
  end
end
