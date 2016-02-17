class AddColumnToExternalSystem < ActiveRecord::Migration
  def change
    add_column :irm_external_systems, :allow_notice_flag, :string #是否允许通知项目经理标志
  end
end
