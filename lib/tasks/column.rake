namespace :irm do
  desc "(For Ironmine)Check Column with column name "
  task :column => :environment do
    name = ENV["NAME"]
    return unless name.present?
    ts = ActiveRecord::Base.connection.execute("show  tables")
    columns = []
    views = []
    ts.each do |t|
      if t.first.end_with?("_vl")||t.first.end_with?("_v")
        views << t.first
        next
      end
      ActiveRecord::Base.connection.execute("describe  #{t.first}").each do |c|
        columns << {:table_name=>t.first,:column_name=>c.first}  if c.first.eql?(name)
      end
    end
    columns.each do |c|
      puts "#{c[:table_name]}, #{c[:column_name]}"
    end
    views.each do |v|
      v_info = ActiveRecord::Base.connection.execute("SHOW CREATE VIEW #{v}").first
      if v_info
        puts v_info.second.gsub(/CREATE.+VIEW/,"CREATE OR REPLACE VIEW").gsub("company_id","opu_id")
      end
    end

  end
end