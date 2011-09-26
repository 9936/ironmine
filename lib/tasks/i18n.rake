namespace :irm do

  desc "Find and list translation keys that do not exist in all locales"
  task :i18n_check => :environment do

    def collect_keys(scope, translations)
      full_keys = []
      translations.to_a.each do |key, translations|
        new_scope = scope.dup << key
        if translations.is_a?(Hash)
          full_keys += collect_keys(new_scope, translations)
        else
          full_keys << new_scope.join('.')
        end
      end
      return full_keys
    end

    # Make sure we've loaded the translations
    I18n.backend.send(:init_translations)
    puts "#{I18n.available_locales.size} #{I18n.available_locales.size == 1 ? 'locale' : 'locales'} available: #{I18n.available_locales.to_sentence}"

    # Get all keys from all locales
    all_keys = I18n.backend.send(:translations).collect do |check_locale, translations|
      collect_keys([], translations).sort
    end.flatten.uniq
    puts "#{all_keys.size} #{all_keys.size == 1 ? 'unique key' : 'unique keys'} found."

    missing_keys = {}
    all_keys.each do |key|

      I18n.available_locales.each do |locale|
        I18n.locale = locale
        begin
          result = I18n.translate(key, :raise => true)
        rescue I18n::MissingInterpolationArgument
          # noop
        rescue I18n::MissingTranslationData
          if missing_keys[locale]
            missing_keys[locale] << key
          else
            missing_keys[locale] = [key]
          end
        end
      end
    end

    #puts "#{missing_keys.size} #{missing_keys.size == 1 ? 'key is missing' : 'keys are missing'} from one or more locales:"
    missing_keys.each do |key,values|
      puts "#{values.size} #{values.size == 1 ? 'key is missing' : 'keys are missing'} from local:#{key}======================"
      values.each do |value|
        puts "#{value}"
      end
    end

  end
end