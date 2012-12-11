module Irm::CustomFields
  #用来扩展ActiveRecord::Base,添加对自定义字段的校验
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def validates_custom_field(options = {:system_flag => 'Y'})
      return if self.included_modules.include?(::Irm::CustomFields::InstanceMethods)
      send :include, ::Irm::CustomFields::InstanceMethods

      cattr_accessor :custom_field_options

      self.custom_field_options = options

      class_eval do
        validate :validate_fields

        def validate_fields
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
          bo = Irm::BusinessObject.where(:bo_model_name => self.class.to_s).first
          if self.custom_field_options[:system_flag] == 'Y' and self.external_system_id
            custom_attributes = Irm::ObjectAttribute.multilingual.list_all.real_field.query_by_business_object(bo.id).where("#{Irm::ObjectAttribute.table_name}.field_type = ? AND #{Irm::ObjectAttribute.table_name}.external_system_id=?","SYSTEM_CUX_FIELD", self.external_system_id)
            custom_attributes +=  Irm::ObjectAttribute.multilingual.list_all.real_field.query_by_business_object(bo.id).with_external_system(self.external_system_id).where("#{Irm::ObjectAttribute.table_name}.field_type = ?","GLOBAL_CUX_FIELD")
          elsif self.custom_field_options[:system_flag] == 'N'
            custom_attributes = Irm::ObjectAttribute.multilingual.list_all.real_field.query_by_business_object(bo.id)
          else
            custom_attributes = []
          end
          custom_attributes
        end

        #设置默认值
        def merge_default_values
          self.custom_attributes.each do |field|
            self[field[:attribute_name].to_sym] = field[:data_default_value]
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