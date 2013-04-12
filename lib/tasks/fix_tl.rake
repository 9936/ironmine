namespace :irm do
  desc "(For Ironmine)Fix Tl Tables language."

  task :fixtl => :environment do
    CLEAR   = "\e[0m"
    BOLD    = "\e[1m"
    RED     = "\e[31m"
    GREEN   = "\e[32m"
    YELLOW  = "\e[33m"
    BLUE    = "\e[34m"

    #tables = ActiveRecord::Base.connection.tables
    ##只保留tl表
    #tables.delete_if {|i| !i.match(/^[a-z]+[a-z|_]*_tl$/i) }

    #当前启用的语言
    puts "Starting fix tl tables......"
    languages = Irm::Language.enabled.installed.current_code_description.collect{|language|language[:language_code]}

    begin
      rails_config = Rails.application.config
      rails_config.fwk.modules.each do |module_name|
        Dir["#{Rails.root}/#{rails_config.fwk.module_folder}/#{rails_config.fwk.module_mapping[module_name]}/app/models/#{module_name}/*.rb"].each do |file|
          begin
            require file
          rescue
          end
        end
      end
    end

    ActiveRecord::Base.subclasses.each do |type|
      model = type.name.constantize
      if model.table_name.match(/^[a-z]+[a-z|_]*_tl$/i)
        model.where("language = ?", "en").each do |t|
          languages.each do |language|
            if language.eql?("en")
              next
            end
            unless model.where("language = ?", language)
              miss_language = model.new(t.attributes)
              miss_language.id = nil
              miss_language.language = language
              #miss_language.save
            end
          end
        end
      end
    end
    puts "Fixed successfully......"
    ##查看表中的记录数是否已经填写
    #tables.each do |table|
    #  #需要
    #  languages.each do |language|
    #    result = ActiveRecord::Base.connection.execute("SELECT * FROM #{table} where language=#{language}").first
    #    unless result > 0
    #      en_result = ActiveRecord::Base.connection.execute("SELECT * FROM #{table} where language=#{language}").first
    #      ActiveRecord::Base.connection.insert_sql("")
    #    end
    #  end
    #
    #  puts result.count
    #end

  end
end