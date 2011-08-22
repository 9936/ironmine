namespace :irm do
  desc "(For Ironmine)Check Column with column name "
  task :column => :environment do
    name = ENV["NAME"]
    return unless name.present?
    ts = ActiveRecord::Base.connection.execute("show  tables")
    columns = []
    ts.each do |t|
      next if t.first.end_with?("_vl")||t.first.end_with?("_v")
      ActiveRecord::Base.connection.execute("describe  #{t.first}").each do |c|
        columns << {:table_name=>t.first,:column_name=>c.first}  if c.first.end_with?(name)
      end
    end
    columns.each do |c|
      puts "#{c[:table_name]}, #{c[:column_name]}"
    end
  end
end