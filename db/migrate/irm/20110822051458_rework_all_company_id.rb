class ReworkAllCompanyId < ActiveRecord::Migration
  def self.up
    name = "company_id"
    # 取得数据库中所有的表和视图
    ts = ActiveRecord::Base.connection.execute("show  tables")
    columns = []
    views = []
    ts.each do |t|
      # 排除company相关的表
      next if ["irm_companies","irm_companies_tl","irm_companies_vl"].include?(t.first)

      # 取得数据库的视图
      if t.first.end_with?("_vl")||t.first.end_with?("_v")
        views << t.first
        next
      end

      # 取得表中的company_id列
      ActiveRecord::Base.connection.execute("describe  #{t.first}").each do |c|
        columns << {:table_name=>t.first,:column_name=>c.first}  if c.first.eql?(name)
      end
    end


    #生成重新创建含有company_id的视图
    view_create_script = []
    views.each do |v|
      v_info = ActiveRecord::Base.connection.execute("SHOW CREATE VIEW #{v}").first
      if v_info && v_info.second.include?(name)
        # 将视图中的company_id 替换为opu_id
        view_create_script<<v_info.second.gsub(/CREATE.+VIEW/,"CREATE OR REPLACE VIEW").gsub("`company_id`","`opu_id`")
      end
    end

    # 执行脚本将company_id 替换为opu_id
    columns.each do |c|
      rename_column c[:table_name], c[:column_name],"opu_id"
    end

    # 执行脚本重新创建含有company_id的视图
    view_create_script.each do |script|
      execute(script)
    end
  end

  def self.down
  end
end
