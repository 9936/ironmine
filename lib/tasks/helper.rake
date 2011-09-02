namespace :irm do
  desc "(For Ironmine)Check Column with column name "
  task :column_info => :environment do
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

  task :bo_translate => :environment do
    Dir["#{Rails.root}/app/models/*/*.rb"].each { |file| require file }
    models = ActiveRecord::Base.send(:subclasses)
    models.delete_if{|m| m.table_name.end_with?("s_tl")}
    models.each do |m|
      meaning =  Irm::BusinessObject.class_name_to_meaning(m.name)
      if meaning.include?("translation missing")
        puts meaning
      end
    end

  end
end