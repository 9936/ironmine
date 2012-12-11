module Irm::CustomFields
  #用来扩展ActiveRecord::Base,添加对自定义字段的校验
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def validates_custom_field(options = {:system_flag => 'Y'})
      return if self.included_modules.include?(::Irm::CustomFields::InstanceMethods)
      send :include, ::Irm::CustomFields::InstanceMethods

      if options[:system_flag] == 'Y'
        class_eval do
          def custom_attributes
            #取得对应model的自定义字段
            bo = Irm::BusinessObject.where(:bo_model_name => self.class.to_s).first
            if self.external_system_id
              custom_attributes = Irm::ObjectAttribute.list_all.real_field.query_by_business_object(bo.id).where("#{Irm::ObjectAttribute.table_name}.field_type = ? AND #{Irm::ObjectAttribute.table_name}.external_system_id=?","SYSTEM_CUX_FIELD", self.external_system_id)
              custom_attributes +=  Irm::ObjectAttribute.list_all.real_field.query_by_business_object(bo.id).with_external_system(self.external_system_id).where("#{Irm::ObjectAttribute.table_name}.field_type = ?","GLOBAL_CUX_FIELD")
            else
              custom_attributes = []
            end
            custom_attributes
          end
        end
      else
        class_eval do
          def custom_attributes
            #取得对应model的自定义字段
            bo = Irm::BusinessObject.where(:bo_model_name => self.class.to_s).first
            Irm::ObjectAttribute.list_all.real_field.query_by_business_object(bo.id)
          end
        end
      end

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
      end
    end
  end

  module InstanceMethods
    def self.included(base)
      base.extend ClassMethods
    end
  end

end