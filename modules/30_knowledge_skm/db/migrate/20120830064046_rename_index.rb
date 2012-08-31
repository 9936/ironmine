class RenameIndex < ActiveRecord::Migration
  def up
    rename_index "chm_change_incident_relations", "CHM_CHANGE_INCIDENT_RELATIONS_U1", "CHM_CHG_ICDT_RELATIONS_U1"
    rename_index "chm_change_task_templates_tl", "CHM_CHANGE_TASK_TEMPLATES_TL_U1", "CHM_CHG_TASK_TEMPLATES_TL_U1"
    rename_index "chm_change_task_templates_tl", "CHM_CHANGE_TASK_TEMPLATES_TL_N1", "CHM_CHG_TASK_TEMPLATES_TL_N1"
    rename_index "icm_incident_category_systems", "ICM_INCIDENT_CATEGORY_SYSTEMS_N1", "ICM_ICDT_CATEGORY_SYSTEMS_N1"
    rename_index "icm_incident_config_relations", "ICM_INCIDENT_CONFIG_RELATIONS_U1", "ICM_ICDT_CONFIG_RELATIONS_U1"
    rename_index "icm_incident_sub_categories_tl", "ICM_INCIDENT_SUB_CATEGORIES_TL_U1", "ICM_ICDT_SUB_CATEGORIES_TL_U1"
    rename_index "icm_incident_sub_categories_tl", "ICM_INCIDENT_SUB_CATEGORIES_TL_N1", "ICM_ICDT_SUB_CATEGORIES_TL_N1"
    rename_index "irm_organization_infos", "index_irm_organization_infos_on_name", "IRM_ORG_INFOS_N1"
    rename_index "irm_organization_infos", "index_irm_organization_infos_on_organization_id", "IRM_ORG_INFOS_N2"
    rename_index "irm_organization_infos", "index_irm_organization_infos_on_value", "IRM_ORG_INFOS_N3"
    rename_index "irm_report_request_histories", "IRM_REPORT_REQUEST_HISTORIES_N1","IRM_RPT_REQUEST_HISTORIES_N1"
    rename_index "irm_report_type_categories_tl", "IRM_REPORT_TYPE_CATEGORIES_TL_U1", "IRM_RPT_TYPE_CATEGORIES_TL_U1"
  end

  def down
  end
end
