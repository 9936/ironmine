# -*- coding: utf-8 -*-
class ReworkBoData < ActiveRecord::Migration
  def up
    Irm::LookupValue.where(:lookup_type=>'BO_ATTRIBUTE_TYPE').each do |l|
      l.destroy
    end

    bo_attribute_field_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'BO_ATTRIBUTE_FIELD_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_field_type.lookup_types_tls.build(:lookup_type_id=>bo_attribute_field_type.id,:meaning=>'业务对像属性字段类型',:description=>'业务对像属性字段类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_field_type.lookup_types_tls.build(:lookup_type_id=>bo_attribute_field_type.id,:meaning=>'Business Object Field Type',:description=>'Business Object Field Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_field_type.save

    bo_attribute_category=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'BO_ATTRIBUTE_CATEGORY',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_category.lookup_types_tls.build(:lookup_type_id=>bo_attribute_category.id,:meaning=>'业务对像属性数据类别',:description=>'业务对像属性数据类别',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_category.lookup_types_tls.build(:lookup_type_id=>bo_attribute_category.id,:meaning=>'Business Object Data Category',:description=>'Business Object Data Category',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_category.save


    bo_attribute_typemodel_attribute= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_TYPE',:lookup_code=>'MODEL_ATTRIBUTE',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_typemodel_attribute.lookup_values_tls.build(:lookup_value_id=>bo_attribute_typemodel_attribute.id,:meaning=>'Model属性',:description=>'Model属性',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_typemodel_attribute.lookup_values_tls.build(:lookup_value_id=>bo_attribute_typemodel_attribute.id,:meaning=>'Model Attribute',:description=>'Model Attribute',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_typemodel_attribute.save
    bo_attribute_typetable_column= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_TYPE',:lookup_code=>'TABLE_COLUMN',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_typetable_column.lookup_values_tls.build(:lookup_value_id=>bo_attribute_typetable_column.id,:meaning=>'表格列',:description=>'表格列',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_typetable_column.lookup_values_tls.build(:lookup_value_id=>bo_attribute_typetable_column.id,:meaning=>'Table Column',:description=>'Table Column',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_typetable_column.save

    bo_attribute_field_typestandard_field= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_FIELD_TYPE',:lookup_code=>'STANDARD_FIELD',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_field_typestandard_field.lookup_values_tls.build(:lookup_value_id=>bo_attribute_field_typestandard_field.id,:meaning=>'标准字段',:description=>'标准字段',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_field_typestandard_field.lookup_values_tls.build(:lookup_value_id=>bo_attribute_field_typestandard_field.id,:meaning=>'Standard Field',:description=>'Standard Field',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_field_typestandard_field.save
    bo_attribute_field_typecustomize_field= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_FIELD_TYPE',:lookup_code=>'CUSTOMIZE_FIELD',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_field_typecustomize_field.lookup_values_tls.build(:lookup_value_id=>bo_attribute_field_typecustomize_field.id,:meaning=>'自定义字段',:description=>'自定义字段',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_field_typecustomize_field.lookup_values_tls.build(:lookup_value_id=>bo_attribute_field_typecustomize_field.id,:meaning=>'Customize Field',:description=>'Customize Field',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_field_typecustomize_field.save
    bo_attribute_categorylookup_relation= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_CATEGORY',:lookup_code=>'LOOKUP_RELATION',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_categorylookup_relation.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorylookup_relation.id,:meaning=>'查找关系',:description=>'创建一个将此对象链接到另一对象的关系。关系字段允许用户单击查找图标，以从弹出列表中选择值。另一对象是列表中值的源。',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorylookup_relation.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorylookup_relation.id,:meaning=>'Lookup Relationship',:description=>'Creates a relationship that links this object to another object. The relationship field allows users to click on a lookup icon to select a value from a popup list. The other object is the source of the values in the list.',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorylookup_relation.save
    bo_attribute_categorymaster_detail_relation= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_CATEGORY',:lookup_code=>'MASTER_DETAIL_RELATION',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_categorymaster_detail_relation.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorymaster_detail_relation.id,:meaning=>'主-详细信息关系',:description=>'创建一个此对象（子级或""详细信息""）与另一对象（父级或""主""）之间的特殊父子关系类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorymaster_detail_relation.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorymaster_detail_relation.id,:meaning=>'Master-Detail Relationship',:description=>'Creates a special type of parent-child relationship between this object (the child, or ""detail"") and another object (the parent, or ""master"")',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorymaster_detail_relation.save
    bo_attribute_categorycheck_box= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_CATEGORY',:lookup_code=>'CHECK_BOX',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_categorycheck_box.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorycheck_box.id,:meaning=>'复选框',:description=>'允许用户选择""真""（选取）或""假""（不选取）值。',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorycheck_box.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorycheck_box.id,:meaning=>'Checkbox',:description=>'Allows users to select a True (checked) or False (unchecked) value.',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorycheck_box.save
    bo_attribute_categorydate_time= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_CATEGORY',:lookup_code=>'DATE_TIME',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_categorydate_time.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorydate_time.id,:meaning=>'日期/时间',:description=>'允许用户输入日期和时间，或从弹出式日历中选择日期。当用户单击弹出式日历中的某个日期后，该日期和当前时间将输入到""日期/时间""字段。',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorydate_time.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorydate_time.id,:meaning=>'Date/Time',:description=>'Allows users to enter a date and time, or pick a date from a popup calendar. When users click a date in the popup, that date and the current time are entered into the Date/Time field.',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorydate_time.save
    bo_attribute_categoryemail= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_CATEGORY',:lookup_code=>'EMAIL',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_categoryemail.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categoryemail.id,:meaning=>'电子邮件',:description=>'允许用户输入电子邮件地址，对其进行验证以确保格式正确。如果对于一个联系人和潜在客户指定了此字段，则用户单击“发送电子邮件”时可以选择地址。注意，自定义电子邮件地址无法用于批量电子邮件。',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categoryemail.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categoryemail.id,:meaning=>'Email',:description=>'Allows users to enter an email address, which is validated to ensure proper format. If this field is specified for a contact or lead, users can choose the address when clicking Send an Email. Note that custom email addresses cannot be used for mass emails.',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categoryemail.save
    bo_attribute_categorynumber= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_CATEGORY',:lookup_code=>'NUMBER',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_categorynumber.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorynumber.id,:meaning=>'数字',:description=>'允许用户输入任何数字。将删除前置零。',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorynumber.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorynumber.id,:meaning=>'Number',:description=>'Allows users to enter any number. Leading zeros are removed.',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorynumber.save
    bo_attribute_categoryphone= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_CATEGORY',:lookup_code=>'PHONE',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_categoryphone.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categoryphone.id,:meaning=>'电话',:description=>'允许用户输入任何电话号码。自动将其转换为电话号码格式。',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categoryphone.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categoryphone.id,:meaning=>'Phone',:description=>'Allows users to enter any phone number. Automatically formats it as a phone number.',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categoryphone.save
    bo_attribute_categorypick_list= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_CATEGORY',:lookup_code=>'PICK_LIST',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_categorypick_list.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorypick_list.id,:meaning=>'选项列表',:description=>'允许用户从定义的列表中选择值。',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorypick_list.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorypick_list.id,:meaning=>'Picklist',:description=>'Allows users to select a value from a list you define.',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorypick_list.save
    bo_attribute_categorypick_list_multi= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_CATEGORY',:lookup_code=>'PICK_LIST_MULTI',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_categorypick_list_multi.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorypick_list_multi.id,:meaning=>'选项列表（多项选择）',:description=>'允许用户从定义的列表中选择多个值。',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorypick_list_multi.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorypick_list_multi.id,:meaning=>'Picklist (Multi-Select)',:description=>'Allows users to select multiple values from a list you define.',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorypick_list_multi.save
    bo_attribute_categorytext= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_CATEGORY',:lookup_code=>'TEXT',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_categorytext.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorytext.id,:meaning=>'文本',:description=>'允许用户输入任何字母和数字组合。',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorytext.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorytext.id,:meaning=>'Text',:description=>'Allows users to enter any combination of letters and numbers.',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorytext.save
    bo_attribute_categorytext_area= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_CATEGORY',:lookup_code=>'TEXT_AREA',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_categorytext_area.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorytext_area.id,:meaning=>'文本区域',:description=>'允许用户输入多行文本，最多可输入 255 个字符。',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorytext_area.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorytext_area.id,:meaning=>'Text Area',:description=>'Allows users to enter up to 255 characters on separate lines.',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorytext_area.save
    bo_attribute_categorytext_area_rich= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_CATEGORY',:lookup_code=>'TEXT_AREA_RICH',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_categorytext_area_rich.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorytext_area_rich.id,:meaning=>'文本区域（富文本）',:description=>'允许用户输入格式化文本、添加图片和链接。',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorytext_area_rich.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorytext_area_rich.id,:meaning=>'Text Area (Rich)',:description=>'Allows users to enter formatted text, add images and links. Up to 32,768 characters on separate lines.',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorytext_area_rich.save
    bo_attribute_categoryurl= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_CATEGORY',:lookup_code=>'URL',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_categoryurl.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categoryurl.id,:meaning=>'URL',:description=>'允许用户输入任何有效的网址。',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categoryurl.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categoryurl.id,:meaning=>'URL',:description=>'Allows users to enter any valid website address. When users click on the field, the URL will open in a separate browser window.',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categoryurl.save


  end

  def down
  end
end
