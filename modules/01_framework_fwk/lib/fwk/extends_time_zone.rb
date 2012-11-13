module Fwk::ExtendsTimeZone
  def self.included(base)
    base.class_eval do
      def to_s
        translated_name = I18n.t(name, :scope => :timezones, :default => name)
        "(GMT#{formatted_offset}) #{translated_name}"
      end
    end
  end
end