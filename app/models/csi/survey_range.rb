class Csi::SurveyRange < ActiveRecord::Base
  set_table_name :csi_survey_ranges

  query_extend
  belongs_to :survey

  scope :query_by_survey_id,lambda{|survey_id| where(:survey_id=>survey_id)}

  scope :query_wrap_info,lambda{|language| select("#{table_name}.*,v1.meaning status_meaning,v2.meaning range_type_meaning").
                                                   joins(",irm_lookup_values_vl v1").
                                                   joins(",irm_lookup_values_vl v2").
                                                   where("v1.lookup_type='SYSTEM_STATUS_CODE' AND v1.lookup_code = #{table_name}.status_code AND "+
                                                         "v2.lookup_type='CSI_SURVEY_RANGE_TYPE' AND v2.lookup_code = #{table_name}.range_type AND "+
                                                         "v1.language=? AND v2.language = ?",language,language)}


  scope :query_status_meaning,lambda{|language| select("#{table_name}.*,v1.meaning status_meaning").
                                                   joins("inner join irm_lookup_values_vl v1").
                                                   where("v1.lookup_type='SYSTEM_STATUS_CODE' AND v1.lookup_code = #{table_name}.status_code AND "+
                                                         "v1.language=? ",language)}

  scope :query_range_meaning,lambda{|language| select("v2.meaning range_type_meaning").
                                                   joins("inner join irm_lookup_values_vl v2").
                                                   where("v2.lookup_type='CSI_SURVEY_RANGE_TYPE' AND v2.lookup_code = #{table_name}.range_type AND "+
                                                         "v2.language=? ",language)}


  scope :query_all_info,select("v3.name company_name,v4.name organization_name, v5.name department_name,v6.name role_name,v7.name site_name").
                        joins("left outer join irm_companies_vl v3 ON v3.id = #{table_name}.range_company_id AND v3.language = v1.language").
                        joins("left outer join irm_organizations_vl v4 ON v4.id = #{table_name}.range_organization_id AND v4.language = v1.language").
                        joins("left outer join irm_departments_vl v5 ON v5.id = #{table_name}.range_department_id and v5.language = v1.language").
                        joins("left outer join irm_roles_vl v6 ON v6.id = #{table_name}.role_id AND v6.language = v1.language").
                        joins("left outer join irm_sites_vl v7 ON v7.id = #{table_name}.site_id AND v7.language = v1.language")

  scope :with_company, lambda{
    select("ct.name source_name, '#{I18n.t("label_"+Irm::Company.name.underscore.gsub("\/","_"))}' source_type_name").
        joins(",#{Irm::Company.table_name} c, #{Irm::CompaniesTl.table_name} ct").
        where("c.id = ct.company_id").
        where("ct.language=?",I18n.locale).
        where("c.id=#{table_name}.source_id").
        where("#{table_name}.source_type=?", Irm::Company.name)
  }

  scope :with_organization, lambda{
    select("concat(oc.name, '-', ot.name) source_name, '#{I18n.t("label_"+Irm::Organization.name.underscore.gsub("\/","_"))}' source_type_name").
        joins(",#{Irm::Organization.table_name} o,#{Irm::OrganizationsTl.table_name} ot,#{Irm::CompaniesTl.table_name} oc").
        where("o.id = ot.organization_id").
        where("ot.language=?",I18n.locale).
        where("o.id=#{table_name}.source_id").
        where("#{table_name}.source_type=?", Irm::Organization.name).
        where("oc.language=ot.language").
        where("oc.company_id=o.company_id")

  }

  scope :with_department, lambda{
    select("concat(dc.name, '-', do.name, '-', dt.name) source_name, '#{I18n.t("label_"+Irm::Department.name.underscore.gsub("\/","_"))}' source_type_name").
        joins(",#{Irm::Department.table_name} d, #{Irm::DepartmentsTl.table_name} dt, #{Irm::OrganizationsTl.table_name} do, #{Irm::CompaniesTl.table_name} dc").
        where("d.id = dt.department_id").
        where("dt.language=?",I18n.locale).
        where("d.id = #{table_name}.source_id").
        where("#{table_name}.source_type=?",Irm::Department.name).
        where("dc.company_id=d.company_id").
        where("do.language=dc.language").
        where("do.language=dt.language").
        where("do.organization_id=d.organization_id")
  }

  scope :with_role, lambda{
    select("rt.name source_name, '#{I18n.t("label_"+Irm::Role.name.underscore.gsub("\/","_"))}' source_type_name").
        joins(",#{Irm::Role.table_name} r, #{Irm::RolesTl.table_name} rt").
        where("r.id = rt.role_id").
        where("rt.language=?",I18n.locale).
        where("r.id = #{table_name}.source_id").
        where("#{table_name}.source_type=?",Irm::Role.name)
  }

  scope :with_site, lambda{
    select("st.name source_name, '#{I18n.t("label_"+Irm::Site.name.underscore.gsub("\/","_"))}' source_type_name").
        joins(",#{Irm::Site.table_name} s, #{Irm::SitesTl.table_name} st").
        where("s.id = st.site_id").
        where("st.language=?",I18n.locale).
        where("s.id = #{table_name}.source_id").
        where("#{table_name}.source_type=?",Irm::Site.name)
  }

  scope :select_all, lambda{|survey_id|
    select("#{table_name}.*").where("#{table_name}.survey_id=?",survey_id)
  }

  def self.query_range_person_count(survey_id)
    Csi::SurveyMember.query_by_survey_id(survey_id).count
  end


  def person_ids
    person_ids = []

    case self.source_type
      when Irm::Company.name
        person_ids << Irm::Person.enabled.select("id").where("company_id=?",self.source_id).collect{|i| i.id}
      when Irm::Organization.name
        person_ids << Irm::Person.enabled.select("id").where("organization_id = ?", self.source_id).collect{|i| i.id}
      when Irm::Department.name
        person_ids << Irm::Person.enabled.select("id").where("department_id = ?", self.source_id).collect{|i| i.id}
      when Irm::Role.name
        person_ids << Irm::Person.select("id").where(:role_id => self.source_id).collect{|i| i.id}
      when Irm::Site.name

    end

    person_ids.flatten!
    person_ids.uniq!
    person_ids
  end

  def self.list_all(survey_id)
    result = Csi::SurveyRange.select_all(survey_id).with_company +
        Csi::SurveyRange.select_all(survey_id).with_organization +
        Csi::SurveyRange.select_all(survey_id).with_department +
        Csi::SurveyRange.select_all(survey_id).with_role +
        Csi::SurveyRange.select_all(survey_id).with_site
    result
  end

  #acts_as_recently_objects(:title => "title",
  #                         :target_controller => "csi/surveys",
  #                         :target => "survey")
end
