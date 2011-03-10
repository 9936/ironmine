class Csi::SurveyRange < ActiveRecord::Base
  set_table_name :csi_survey_ranges

  query_extend

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

end
