class Sug::Contact < ActiveRecord::Base
  set_table_name :sug_contacts

  has_many :addresses, :foreign_key => :source_id, :dependent => :destroy

  validates_presence_of :first_name

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  accepts_nested_attributes_for :addresses

  def self.list_all
    select_all.
        with_sex_meaning(I18n.locale).
        with_default_address
  end



  scope :owned_by_customer, lambda{|customer_id|
    joins("JOIN #{Sug::CustomerContact.table_name} sc ON sc.contact_id=#{table_name}.id").
        where("sc.customer_id=?", customer_id)
  }

  scope :available_by_customer, lambda {|customer_id|
    where("NOT EXISTS (SELECT * FROM #{Sug::CustomerContact.table_name} sc WHERE sc.contact_id = #{table_name}.id AND sc.customer_id = ?)", customer_id)
  }


  scope :with_default_address, lambda {
    joins("LEFT JOIN sug_addresses_vl av on #{self.table_name}.id = av.source_id").
        select("av.address_name").
        where("av.source_type=? AND av.default_flag=?", "Sug::Contact", 'Y')
  }

  scope :with_sex_meaning, lambda {|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} lv ON lv.lookup_type='SUG_SEX' AND lv.lookup_code = #{table_name}.sex AND lv.language= '#{language}'").
        select(" lv.meaning sex_name")
  }
end
