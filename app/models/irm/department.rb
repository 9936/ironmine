class Irm::Department < ActiveRecord::Base
  set_table_name :irm_departments

  #多语言关系
  attr_accessor :name,:description
  has_many :departments_tls,:dependent => :destroy
  acts_as_multilingual

  validates_presence_of :short_name,:organization_id,:company_id
  validates_uniqueness_of :short_name, :if => Proc.new { |i| !i.short_name.blank? }
  validates_format_of :short_name, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.short_name.blank?}

  #加入activerecord的通用方法和scope
  query_extend

  scope :query_by_short_name,lambda{|short_name|
    where(:short_name=>short_name)
  }

  scope :query_by_organization,lambda{|organization_id|
    where(:organization_id=>organization_id)
  }

  scope :query_all_department,lambda{|company_id,organization_id|
    where("#{table_name}.company_id=? and #{table_name}.organization_id=?",company_id,organization_id)
  }

  scope :query_wrap_info,lambda{|language| select("#{table_name}.*,#{Irm::DepartmentsTl.table_name}.name,#{Irm::DepartmentsTl.table_name}.description,"+
                                                          "v1.meaning status_meaning,v2.name company_name,v3.name organization_name").
                                                   joins(",irm_lookup_values_vl v1").
                                                   joins(",irm_companies_vl v2").
                                                   joins(",irm_organizations_vl v3").
                                                   where("v1.lookup_type='SYSTEM_STATUS_CODE' AND v1.lookup_code = #{table_name}.status_code AND "+
                                                         "#{table_name}.company_id = v2.id AND v2.language=? AND "+
                                                         "#{table_name}.organization_id = v3.id AND v3.language=? AND "+
                                                         "v1.language=?",language,language,language)}


  scope :query_by_company_and_organization,lambda{|language,company_id,organization_id| select("#{table_name}.id,#{Irm::DepartmentsTl.table_name}.name").
                                                              joins(:departments_tls).
                                                              where("#{Irm::DepartmentsTl.table_name}.language=? AND " +
                                                                    "#{table_name}.company_id = ? AND #{table_name}.organization_id = ?",
                                                                    language,company_id,organization_id)}

  def to_s
    rec = Irm::Department.multilingual.query_wrap_info(I18n.locale).where(:id => self.id).first
    rec[:company_name] + "-" + rec[:organization_name] + "-" + rec[:name]
  end
end
