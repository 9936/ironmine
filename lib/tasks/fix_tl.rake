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
      if model.respond_to?(:multilingual)&&model.respond_to?(:view_name)
        lang_model = model.multilingual_options[:lang_model].constantize
        lang_relation = model.multilingual_options[:lang_relation]

        model.all.each do |mt|
          current_languages = []
          en_tl = nil
          mt.send(lang_relation.to_sym).each do |lang|
            if lang[:language].eql?("en")
              en_tl = lang
            end
            current_languages << lang[:language]
          end
          missing_tls = languages - current_languages
          if en_tl.present? && missing_tls.any?
            missing_tls.each do |missing_tl|
              puts "Add #{missing_tl} record to #{lang_model.table_name}"
              miss_language = lang_model.new(en_tl.attributes)
              miss_language.id = nil
              miss_language.language = missing_tl
              miss_language.save
            end

          end
        end

      end



      #foreign_key = nil
      #
      #if model.table_name.match(/^[a-z]+[a-z|_]*_tl$/i)
      #
      #  model.where("language = ?", "en").each do |t|
      #    unless foreign_key.present?
      #      t.attribute_names.each do |at|
      #        if !at.eql?("opu_id") && at.match(/^[a-z|_]+_id$/i)
      #          if t[at.to_sym].present?
      #            foreign_key = at
      #            break
      #          end
      #        end
      #      end
      #    end
      #
      #    ['zh','en', 'ja'].each do |language|
      #      if language.eql?("en")
      #        next
      #      end
      #      unless model.where("language = ? AND #{foreign_key}=?", language, t[foreign_key.to_sym]).first.present?
      #        puts "Add #{language} record to #{model.table_name},  #{foreign_key}"
      #
      #        miss_language = model.new(t.attributes)
      #        miss_language.id = nil
      #        miss_language.language = language
      #        miss_language.save
      #      end
      #    end
      #  end
      #end
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