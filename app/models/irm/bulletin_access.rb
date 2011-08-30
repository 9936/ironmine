class Irm::BulletinAccess < ActiveRecord::Base
  set_table_name :irm_bulletin_accesses

  belongs_to :irm_bulletins

  scope :with_bulletin, lambda{|bulletin_id|
    where("#{table_name}.bulletin_id = ?", bulletin_id)
  }

  scope :select_all, lambda{
    select("#{table_name}.* ")
  }
end