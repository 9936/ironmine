class UpdateCustomizeFieldToCustomedField < ActiveRecord::Migration
  def up
    Irm::ObjectAttribute.update_all("field_type = 'CUSTOMED_FIELD'","field_type = 'CUSTOMIZE_FIELD'")

    bo_attribute_field_typecustomize_field = Irm::LookupValue.where(:lookup_type=>'BO_ATTRIBUTE_FIELD_TYPE',:lookup_code=>'CUSTOMIZE_FIELD').first
    if bo_attribute_field_typecustomize_field.present?
      bo_attribute_field_typecustomize_field.update_attribute(:lookup_code,"CUSTOMED_FIELD")
    end

  end

  def down
  end
end
