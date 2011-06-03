class Irm::Organization < ActiveRecord::Base
  set_table_name :irm_organizations

  #多语言关系
  attr_accessor :name,:description
  has_many :organizations_tls,:dependent => :destroy
  acts_as_multilingual

  validates_presence_of :short_name,:company_id
  validates_uniqueness_of :short_name, :if => Proc.new { |i| !i.short_name.blank? }
  validates_format_of :short_name, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.short_name.blank?}

  #加入activerecord的通用方法和scope
  query_extend

  scope :query_by_short_name,lambda{|short_name|
    where(:short_name=>short_name)
  }

  scope :query_by_company_id,lambda{|company_id|
   where(:company_id=>company_id)
  }

  scope :query_wrap_info,lambda{|language| select("#{table_name}.*,#{Irm::OrganizationsTl.table_name}.name,#{Irm::OrganizationsTl.table_name}.description,"+
                                                          "v1.meaning status_meaning,v2.name company_name").
                                                   joins(",irm_lookup_values_vl v1").
                                                   joins(",irm_companies_vl v2").

                                                   where("v1.lookup_type='SYSTEM_STATUS_CODE' AND v1.lookup_code = #{table_name}.status_code AND "+
                                                         "#{table_name}.company_id = v2.id AND v2.language=? AND "+
                                                         "v1.language=?",language,language)}

  scope :query_by_company_and_language,lambda{|language,company_id| select("#{Irm::Organization.table_name}.id,#{Irm::OrganizationsTl.table_name}.name").
                                                              joins(:organizations_tls).
                                                              where("#{Irm::OrganizationsTl.table_name}.language=? and " +
                                                                    "#{Irm::Organization.table_name}.company_id = ?",
                                                                    language,company_id)}
  def to_s
    self.company_name + "-" + self.name
  end
end
