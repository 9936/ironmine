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
