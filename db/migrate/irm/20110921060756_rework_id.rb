class ReworkId < ActiveRecord::Migration
  def up
    ts = ActiveRecord::Base.connection.execute("show  tables")
    columns = []
    ci_array = ["created_by","updated_by"]
    ts.each do |t|
      next if t.first.end_with?("_vl")||t.first.end_with?("_v")
      ActiveRecord::Base.connection.execute("describe  #{t.first}").each do |c|
        columns << {:table_name=>t.first,:column_name=>c.first}  if c.first.end_with?("id")||c.first.end_with?("_by")
      end
    end
    columns.each do |c|
      change_column c[:table_name], c[:column_name], :string,:limit=>22, :collate=>"utf8_bin"
    end
    execute("ALTER TABLE `irm_object_codes` CHANGE `id` `id` int(11) DEFAULT NULL auto_increment  NOT NULL")
    execute("ALTER TABLE `irm_machine_codes` CHANGE `id` `id` int(11) DEFAULT NULL auto_increment  NOT NULL")
    change_column :delayed_jobs, "locked_by", :string,:limit=>255
    change_column :irm_object_codes, "object_code", :string,:limit=>4, :collate=>"utf8_bin"
    change_column :irm_machine_codes, "machine_code", :string,:limit=>4, :collate=>"utf8_bin"
    ts.each do |t|
      next  if t.first.end_with?("_vl")||t.first.end_with?("_v")
      Irm::ObjectCode.code(t.first)
    end
  end

  def down
  end
end
