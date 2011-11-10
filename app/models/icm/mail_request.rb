class Icm::MailRequest < ActiveRecord::Base
  set_table_name :icm_mail_requests

  validates_presence_of :username, :password, :external_system_id, :service_code

  scope :select_all, lambda{select("#{table_name}.* ")}

  scope :with_external_system, lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::ExternalSystem.view_name} external_system ON external_system.id = #{table_name}.external_system_id AND external_system.language = '#{language}'").
        select("external_system.system_name external_system_name")
  }

  # 查询出紧急度
  scope :with_urgency,lambda{|language|
    joins("LEFT OUTER JOIN #{Icm::UrgenceCode.view_name} urgence_code ON  urgence_code.id = #{table_name}.urgency_id AND urgence_code.language= '#{language}'").
    select(" urgence_code.name urgency_name")
  }
  # 查询出影响度
  scope :with_impact_range,lambda{|language|
    joins("LEFT OUTER JOIN #{Icm::ImpactRange.view_name} impact_range ON  impact_range.id = #{table_name}.impact_range_id AND impact_range.language= '#{language}'").
    select(" impact_range.name impact_range_name")
  }

  # 查询支持组
  scope :with_support_group,lambda{|language|
    joins("LEFT OUTER JOIN #{Icm::SupportGroup.table_name} ON  #{table_name}.support_group_id = #{Icm::SupportGroup.table_name}.id").
    joins("LEFT OUTER JOIN #{Irm::Group.view_name} ON  #{Icm::SupportGroup.table_name}.group_id = #{Irm::Group.view_name}.id AND #{Irm::Group.view_name}.language= '#{language}'").
    select(" #{Irm::Group.view_name}.name support_group_name")
  }

  # 查询出服务
  scope :with_service,lambda{|language|
    joins("LEFT OUTER JOIN #{Slm::ServiceCatalog.view_name} service ON service.catalog_code = #{table_name}.service_code AND service.language= '#{language}'").
    select(" service.name service_name")
  }

  # 查询出supporter
  scope :with_supporter,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} supporter ON  supporter.id = #{table_name}.support_person_id").
    joins("LEFT OUTER JOIN #{Irm::Organization.view_name} supporter_organization ON  supporter_organization.id = supporter.organization_id AND supporter_organization.language = '#{language}'").
    joins("LEFT OUTER JOIN #{Irm::Profile.view_name} supporter_profile ON  supporter_profile.id = supporter.profile_id AND supporter_profile.language = '#{language}'").
    joins("LEFT OUTER JOIN #{Irm::Role.view_name} supporter_role ON  supporter_role.id = supporter.role_id AND supporter_role.language = '#{language}'").
    select("supporter.full_name supporter_name,supporter_organization.name supporter_organization_name,supporter_profile.name supporter_profile_name,supporter_role.name supporter_role_name")
  }

  query_extend

  def self.list_all
    select_all.
        with_support_group(I18n.locale).
        with_external_system(I18n.locale).
        with_service(I18n.locale).
        with_urgency(I18n.locale).
        with_impact_range(I18n.locale).
        with_supporter(I18n.locale)
  end
end