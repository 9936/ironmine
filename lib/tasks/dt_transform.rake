namespace :irm do
  desc "(For Ironmine)Data Transform"
  task :dtcontrol => :environment do
    CLEAR   = "\e[0m"
    BOLD    = "\e[1m"
    RED     = "\e[31m"



    Dir["#{Rails.root}/app/models/*/*.rb"].each { |file| require file }
    models = ActiveRecord::Base.send(:subclasses)

    key = ENV["C"]

    models.delete_if{|m| !m.name.downcase.include?(key.downcase)} if key.present?

    max_reference_length = 0

    models.each{|m| max_reference_length = m.name.length+5 if max_reference_length < m.name.length+5}

    models.sort{|a,b|a.name<=>b.name}.each do |m|
      next unless m.table_exists?
      puts "#{BOLD}#{RED}#=======================================#{m.name}============================================#{CLEAR}"
      puts "map.entity(#{m.name}.name) do |entity|"

      columns = Array.new(7) { [] }

      ActiveRecord::Base.connection.execute("describe  #{m.table_name}").each do |c|
        next if ["created_at","updated_at"].include?(c[0])
        data_type_length = c[1].split("(")
        data_type = data_type_length[0]
        length = nil
        length = data_type_length[1].gsub(/\)/,"") if data_type_length[1]
        str  = "  "
        if c[0].eql?("status_code")
          columns[0]<< "entity.column"
          columns[1]<< " :#{c[0]}"
          columns[2]<< ",:#{data_type}"
          columns[3]<< ""
        elsif c[0].end_with?("code")||c[0].eql?("short_name")
          columns[0]<< "entity.key"
          columns[1]<< " :#{c[0]}"
          columns[2]<< ",:#{data_type}"
          columns[3]<< ""
        elsif c[0].eql?("id")
          columns[0]<< "entity.primary_key"
          columns[1]<< " :#{c[0]}"
          columns[2]<< ",:#{data_type}"
          columns[3]<< ""
        elsif c[0].eql?("opu_id")
          columns[0]<< "entity.key_reference"
          columns[1]<< " :#{c[0]}"
          columns[2]<< ",:#{data_type}"
          columns[3]<< ",Irm::OperationUnit.name"
        elsif ["created_by","updated_by"].include?(c[0])
          columns[0]<< "entity.reference"
          columns[1]<< " :#{c[0]}"
          columns[2]<< ",:#{data_type}"
          columns[3]<< ",Irm::Person.name"
        elsif c[0].end_with?("_id")
          columns[0]<< "entity.reference"
          columns[1]<< " :#{c[0]}"
          columns[2]<< ",:#{data_type}"
          columns[3]<< ",'reference'"
        else
          columns[0]<< "entity.column"
          columns[1]<< " :#{c[0]}"
          columns[2]<< ",:#{data_type}"
          columns[3]<< ""
        end
        if length.present?
          columns[4]<< ",:limit=>#{length}"
        else
          columns[4]<< ""
        end
        columns[5]<< ",:null=>#{"NO".eql?(c[2]) ? "false" : 'true'}"
        if c[4].present?
          columns[6] << ",:default=>'#{c[4]}'"
        else
          columns[6] << ""
        end
      end
      text_length = []
      0.upto(columns.length-1) do |i|
        length = 0
        columns[i].each do |t|
          length = t.length if length < t.length
        end
        text_length[i] = length
      end

      text_length[3] = max_reference_length

      0.upto(columns[0].length-1) do |i|
        str = "  "
        0.upto(columns.length-1) do |j|
          str << columns[j][i].ljust(text_length[j])
        end
        if str.include?("entity.reference")||str.include?("entity.key")||str.include?("entity.primary_key")
          puts "#{BOLD}#{RED}#{str}#{CLEAR}"
        else
          puts str
        end
      end
      puts "end"
    end

  end

  desc "(For Ironmine)Data Transform Download from source"
  task :dtdownload => :environment do
    start = Time.now
    require "irm/data_struct_define"
    require "data_transform/control"
    source  = Irm::LookupValue.all.collect{|i| {:type=>i.class.name,:condition=>{:id=>i.id}}}

    data = Irm::DataTransform.instance.download(source)
    data.sort{|a,b| a[:origin_type]<=>b[:origin_type]}
    puts data
    File.open(Rails.root + "public/temp.json","w") do |f|
      f.write(data.to_json)
    end
    puts Time.now - start
  end
end