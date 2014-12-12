include ActionView::Helpers::SanitizeHelper

class Mam::MasterItem < ActiveRecord::Base
  set_table_name :mam_master_items
  query_extend
  belongs_to :master
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_template, lambda{
    select("lvt.meaning template_name, lvt.lookup_code template_code").
    joins("LEFT OUTER JOIN irm_lookup_values_vl lvt ON lvt.language = 'en' AND lvt.lookup_type = 'MAM_TEMPLATE' AND lvt.lookup_code = #{table_name}.template")
  }

  scope :with_department, lambda{
    select("CONCAT(lvta.lookup_code, '-', lvta.meaning) department_name, lvta.lookup_code department_code").
        joins("LEFT OUTER JOIN irm_lookup_values_vl lvta ON lvta.language = 'en' AND lvta.lookup_type = 'MAM_DEPARTMENT' AND lvta.lookup_code = #{table_name}.department")
  }

  scope :with_business_unit, lambda{
    select("CONCAT(lvtb.lookup_code, '-', lvtb.meaning) business_unit_name, lvtb.lookup_code business_unit_code").
        joins("LEFT OUTER JOIN irm_lookup_values_vl lvtb ON lvtb.language = 'en' AND lvtb.lookup_type = 'MAM_BUSINESS_UNIT' AND lvtb.lookup_code = #{table_name}.business_unit")
  }

  scope :with_inv_account, lambda{
    select("CONCAT(lvtc.lookup_code, '-', lvtc.meaning) inventory_account_name, lvtc.lookup_code inventory_account_code").
        joins("LEFT OUTER JOIN irm_lookup_values_vl lvtc ON lvtc.language = 'en' AND lvtc.lookup_type = 'MAM_INV_ACCOUNT' AND lvtc.lookup_code = #{table_name}.inventory_account")
  }

  scope :with_inv_sub_account, lambda{
    select("CONCAT(lvtd.lookup_code, '-', lvtd.meaning) inventory_sub_account_name, lvtd.lookup_code inventory_sub_account_code").
        joins("LEFT OUTER JOIN irm_lookup_values_vl lvtd ON lvtd.language = 'en' AND lvtd.lookup_type = 'MAM_INV_SUB_ACCOUNT' AND lvtd.lookup_code = #{table_name}.inventory_sub_account")
  }

  scope :with_sng, lambda{
    select("lvt2.meaning sng_name, lvt2.lookup_code sng_code").
        joins("LEFT OUTER JOIN irm_lookup_values_vl lvt2 ON lvt2.language = 'en' AND lvt2.lookup_type = 'MAM_SNG' AND lvt2.lookup_code = #{table_name}.sn_generation")
  }

  scope :with_replace_br, lambda{
    select("REPLACE(item_description, '\r\n', '<BR>') item_description_br").
        select("REPLACE(department, '\r\n', '<BR>') department_br").
        select("REPLACE(business_unit, '\r\n', '<BR>') business_unit_br").
        select("REPLACE(inventory_account, '\r\n', '<BR>') inventory_account_br").
        select("REPLACE(inventory_sub_account, '\r\n', '<BR>') inventory_sub_account_br")
  }
end
