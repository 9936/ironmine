class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if options[:after]
      unless record[options[:after]] < value
        record.errors[attribute] << options[:after_message]
      end
    end

    if options[:before]
      unless record[options[:before]] > value
        record.errors[attribute] << options[:before_message]
      end
    end
  end
end
