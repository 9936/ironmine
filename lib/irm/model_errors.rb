module Irm::ModelErrors
  def self.included(base)
    base.class_eval do
      def generate_message(attribute, type = :invalid, options = {})
        symbol_flag = false
        if options[:message].is_a?(Symbol)
          type = options.delete(:message)
          symbol_flag = true
        end

        defaults = @base.class.lookup_ancestors.map do |klass|
          [ :"#{@base.class.i18n_scope}.errors.models.#{klass.model_name.i18n_key}.attributes.#{attribute}.#{type}",
            :"#{@base.class.i18n_scope}.errors.models.#{klass.model_name.i18n_key}.#{type}" ]
        end

        defaults << type if symbol_flag
        defaults << options.delete(:message)
        defaults << :"#{@base.class.i18n_scope}.errors.messages.#{type}"
        defaults << :"errors.attributes.#{attribute}.#{type}"
        defaults << :"errors.messages.#{type}"

        defaults.compact!
        defaults.flatten!

        key = defaults.shift
        value = (attribute != :base ? @base.send(:read_attribute_for_validation, attribute) : nil)

        options = {
          :default => defaults,
          :model => @base.class.model_name.human,
          :attribute => @base.class.human_attribute_name(attribute),
          :value => value
        }.merge(options)

        I18n.translate(key, options)
      end
    end
  end
end