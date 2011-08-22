class ReassignValueToOpuId < ActiveRecord::Migration
  def self.up
    remove_index(:icm_rule_settings,:opu_id)
    # 取得当前运维中心的id
    opu_id = Irm::OperationUnit.first.id

    # 当前系统中所有的表
    ts = ActiveRecord::Base.connection.execute("show  tables")
    ts.each do |t|
      # 排除公司相关的表
      next if ["irm_companies","irm_companies_tl","irm_companies_vl"].include?(t.first)
      # 排除视图
      if t.first.end_with?("_vl")||t.first.end_with?("_v")
        next
      end
      # 查找含有opu_id列的表，并将opu_id更新为当前运维中心id
      columns = ActiveRecord::Base.connection.execute("describe  #{t.first}")
      if columns.detect{|i| i.first.eql?("opu_id")}
        execute("UPDATE #{t.first} SET opu_id = '#{opu_id}'")
      end
    end
  end

  def self.down
  end
end
