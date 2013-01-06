module Irm::Customizable
  #用来扩展ActiveRecord::Base,添加对自定义字段的校验
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    def acts_as_customizable(options = {:system_flag => 'Y'})
      return if self.included_modules.include?(::Irm::Customizable::InstanceMethods)
      send :include, ::Irm::Customizable::InstanceMethods

      cattr_accessor :custom_field_options

      self.custom_field_options = options

      class_eval do
        validate :validate_custom_fields

        def validate_custom_fields
          self.custom_attributes.each do |attribute|
            #检查是否必填
            if self[attribute[:attribute_name]].blank? and attribute[:required_flag].eql?('Y')
              self.errors.add attribute[:attribute_name], I18n.t("activerecord.errors.messages.blank")
            end

            #检查长度是否合适
            if self[attribute[:attribute_name]].present? and (attribute[:min_length] > 0 or attribute[:max_length] > 0)
              if  self[attribute[:attribute_name]].length < attribute[:min_length]
                self.errors.add attribute[:attribute_name], I18n.t("activerecord.errors.messages.too_short", :count => attribute[:min_length])
              elsif self[attribute[:attribute_name]].length > attribute[:max_length]
                self.errors.add attribute[:attribute_name], I18n.t("activerecord.errors.messages.too_long", :count => attribute[:max_length])
              end
            end

            #数字类型的添加判断
            if self[attribute[:attribute_name]].present? and "NUMBER".eql?(attribute[:category]) and self[attribute[:attribute_name]].match(/\D{1,}/)
              self.errors.add attribute[:attribute_name], I18n.t("activerecord.errors.messages.number")
            end
          end
        end

        #取得对应model的自定义字段
        def custom_attributes
          if @custom_attributes
            return @custom_attributes
          end
          bo = Irm::BusinessObject.with_custom_flag.where(:bo_model_name => self.class.to_s).first
          if bo.present? and self.custom_field_options[:system_flag] == Irm::Constant::SYS_YES and self.external_system_id
            custom_attributes = Irm::ObjectAttribute.
                where(:status_code => "ENABLED").multilingual.list_all.real_field.query_by_business_object(bo.id).order_by_sequence.with_external_system(self.external_system_id).
                where("#{Irm::ObjectAttribute.table_name}.field_type = ?","GLOBAL_CUX_FIELD")
            custom_attributes += Irm::ObjectAttribute.
                where(:status_code => "ENABLED").multilingual.list_all.real_field.query_by_business_object(bo.id).order_by_sequence.
                where("#{Irm::ObjectAttribute.table_name}.field_type = ? AND #{Irm::ObjectAttribute.table_name}.external_system_id=?","SYSTEM_CUX_FIELD", self.external_system_id)
          elsif bo.present? and self.custom_field_options[:system_flag] == Irm::Constant::SYS_NO
            custom_attributes = Irm::ObjectAttribute.
                where(:status_code => "ENABLED").multilingual.list_all.real_field.query_by_business_object(bo.id).order_by_sequence
          else
            custom_attributes = []
          end

          #将必填放入到前面
          @custom_attributes = [], required = [], options = []
          custom_attributes.each do |ca|
            if ca.required_flag.eql?(Irm::Constant::SYS_YES)
               required << ca
            else
              options << ca
            end
          end
          @custom_attributes = required + options
        end

        #获取对应model下必输的自定义属性
        def required_custom_attributes
          required_attributes = []
          if self.custom_attributes.any?
            self.custom_attributes.each do |attribute|
              if attribute[:required_flag].eql?('Y')
                required_attributes << attribute
              end
            end
          end
          required_attributes
        end

        #对象初始化完成后同步其默认值
        #当对象一旦经过修改后不推荐再调用该方法，否则当可选字段默认值存在时，填写的值时将会自动设置为默认值
        def merge_default_values
          self.custom_attributes.each do |field|
            self[field[:attribute_name].to_sym] = field[:data_default_value] unless self[field[:attribute_name].to_sym].present?
          end
          self
        end
      end
    end
  end

  module InstanceMethods
    def self.included(base)
      base.extend ClassMethods
    end
  end

end