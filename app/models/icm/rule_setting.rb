class Icm::RuleSetting < ActiveRecord::Base
  set_table_name :icm_rule_settings

  validates_presence_of :company_id
  validates_uniqueness_of :company_id

  #加入activerecord的通用方法和scope
  query_extend


  # 查询公司
  scope :with_company,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::Company.view_name} company ON  company.id = #{table_name}.company_id AND company.language= '#{language}'").
    select(" company.name company_name")
  }

  def self.list_all
    select("#{table_name}.*").with_company(I18n.locale).status_meaning
  end

end
