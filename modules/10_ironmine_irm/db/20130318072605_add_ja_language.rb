class AddJaLanguage < ActiveRecord::Migration
  def up
    #chm_change_impacts_tl
    Chm::ChangeImpactsTl.where("language = ?", "en").each do |t|
      new_value = Chm::ChangeImpactsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #chm_change_plan_types_tl
    Chm::ChangePlanTypesTl.where("language = ?", "en").each do |t|
      new_value = Chm::ChangePlanTypesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #chm_change_priorities_tl
    Chm::ChangePrioritiesTl.where("language = ?", "en").each do |t|
      new_value = Chm::ChangePrioritiesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #chm_change_statuses_tl
    Chm::ChangeStatusesTl.where("language = ?", "en").each do |t|
      new_value = Chm::ChangeStatusesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #chm_change_task_phases_tl
    Chm::ChangeTaskPhasesTl.where("language = ?", "en").each do |t|
      new_value = Chm::ChangeTaskPhasesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #chm_change_task_templates_tl
    Chm::ChangeTaskTemplatesTl.where("language = ?", "en").each do |t|
      new_value = Chm::ChangeTaskTemplatesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #chm_change_urgencies_tl
    Chm::ChangeUrgenciesTl.where("language = ?", "en").each do |t|
      new_value = Chm::ChangeUrgenciesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #com_config_attributes_tl
    Com::ConfigAttributesTl.where("language = ?", "en").each do |t|
      new_value = Com::ConfigAttributesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #com_config_classes_tl
    Com::ConfigClassesTl.where("language = ?", "en").each do |t|
      new_value = Com::ConfigClassesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #com_config_item_statuses_tl
    Com::ConfigItemStatusesTl.where("language = ?", "en").each do |t|
      new_value = Com::ConfigItemStatusesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #com_config_relation_types_tl
    Com::ConfigRelationTypesTl.where("language = ?", "en").each do |t|
      new_value = Com::ConfigRelationTypesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #icm_close_reasons_tl
    Icm::CloseReasonsTl.where("language = ?", "en").each do |t|
      new_value = Icm::CloseReasonsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #icm_impact_ranges_tl
    Icm::ImpactRangesTl.where("language = ?", "en").each do |t|
      new_value = Icm::ImpactRangesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #icm_incident_categories_tl
    Icm::IncidentCategoriesTl.where("language = ?", "en").each do |t|
      new_value = Icm::IncidentCategoriesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #icm_incident_phases_tl
    Icm::IncidentPhasesTl.where("language = ?", "en").each do |t|
      new_value = Icm::IncidentPhasesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #icm_incident_statuses_tl
    Icm::IncidentStatusesTl.where("language = ?", "en").each do |t|
      new_value = Icm::IncidentStatusesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #icm_incident_sub_categories_tl
    Icm::IncidentSubCategoriesTl.where("language = ?", "en").each do |t|
      new_value = Icm::IncidentSubCategoriesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #icm_priority_codes_tl
    Icm::PriorityCodesTl.where("language = ?", "en").each do |t|
      new_value = Icm::PriorityCodesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #icm_urgence_codes_tl
    Icm::UrgenceCodesTl.where("language = ?", "en").each do |t|
      new_value = Icm::UrgenceCodesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_applications_tl
    Irm::ApplicationsTl.where("language = ?", "en").each do |t|
      new_value = Irm::ApplicationsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_bu_columns_tl
    Irm::BuColumnsTl.where("language = ?", "en").each do |t|
      new_value = Irm::BuColumnsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_business_objects_tl
    Irm::BusinessObjectsTl.where("language = ?", "en").each do |t|
      new_value = Irm::BusinessObjectsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_cards_tl
    Irm::CardsTl.where("language = ?", "en").each do |t|
      new_value = Irm::CardsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_currencies_tl
    Irm::CurrenciesTl.where("language = ?", "en").each do |t|
      new_value = Irm::CurrenciesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_data_share_rules_tl
    Irm::DataShareRulesTl.where("language = ?", "en").each do |t|
      new_value = Irm::DataShareRulesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_external_systems_tl
    Irm::ExternalSystemsTl.where("language = ?", "en").each do |t|
      new_value = Irm::ExternalSystemsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_flex_values_tl
    #Irm::FlexValuesTl.where("language = ?", "en").each do |t|
    #  new_value = Irm::FlexValuesTl.new(t.attributes)
    #  new_value.language = "ja"
    #  new_value.save
    #end
    #irm_formula_functions_tl
    Irm::FormulaFunctionsTl.where("language = ?", "en").each do |t|
      new_value = Irm::FormulaFunctionsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_function_groups_tl
    Irm::FunctionGroupsTl.where("language = ?", "en").each do |t|
      new_value = Irm::FunctionGroupsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_functions_tl
    Irm::FunctionsTl.where("language = ?", "en").each do |t|
      new_value = Irm::FunctionsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_groups_tl
    Irm::GroupsTl.where("language = ?", "en").each do |t|
      new_value = Irm::GroupsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_id_flex_segments_tl
    #Irm::IdFlexSegmentsTl.where("language = ?", "en").each do |t|
    #  new_value = Irm::IdFlexSegmentsTl.new(t.attributes)
    #  new_value.language = "ja"
    #  new_value.save
    #end
    ##irm_id_flex_structures_tl
    #Irm::IdFlexStructuresTl.where("language = ?", "en").each do |t|
    #  new_value = Irm::IdFlexStructuresTl.new(t.attributes)
    #  new_value.language = "ja"
    #  new_value.save
    #end
    #irm_kanbans_tl
    Irm::KanbansTl.where("language = ?", "en").each do |t|
      new_value = Irm::KanbansTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_lanes_tl
    Irm::LanesTl.where("language = ?", "en").each do |t|
      new_value = Irm::LanesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_languages_tl
    Irm::LanguagesTl.where("language = ?", "en").each do |t|
      new_value = Irm::LanguagesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_licenses_tl
    Irm::LicensesTl.where("language = ?", "en").each do |t|
      new_value = Irm::LicensesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_list_of_values_tl
    Irm::ListOfValuesTl.where("language = ?", "en").each do |t|
      new_value = Irm::ListOfValuesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_lookup_types_tl
    Irm::LookupTypesTl.where("language = ?", "en").each do |t|
      new_value = Irm::LookupTypesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_lookup_values_tl
    Irm::LookupValuesTl.where("language = ?", "en").each do |t|
      new_value = Irm::LookupValuesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_mail_templates_tl
    Irm::MailTemplatesTl.where("language = ?", "en").each do |t|
      new_value = Irm::MailTemplatesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_menu_entries_tl
    Irm::MenuEntriesTl.where("language = ?", "en").each do |t|
      new_value = Irm::MenuEntriesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_menus_tl
    Irm::MenusTl.where("language = ?", "en").each do |t|
      new_value = Irm::MenusTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_object_attributes_tl
    Irm::ObjectAttributesTl.where("language = ?", "en").each do |t|
      new_value = Irm::ObjectAttributesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_operation_units_tl
    Irm::OperationUnitsTl.where("language = ?", "en").each do |t|
      new_value = Irm::OperationUnitsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_organizations_tl
    Irm::OrganizationsTl.where("language = ?", "en").each do |t|
      new_value = Irm::OrganizationsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_portal_layouts_tl
    Irm::PortalLayoutsTl.where("language = ?", "en").each do |t|
      new_value = Irm::PortalLayoutsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_portlets_tl
    Irm::PortletsTl.where("language = ?", "en").each do |t|
      new_value = Irm::PortletsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_product_modules_tl
    Irm::ProductModulesTl.where("language = ?", "en").each do |t|
      new_value = Irm::ProductModulesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_profiles_tl
    Irm::ProfilesTl.where("language = ?", "en").each do |t|
      new_value = Irm::ProfilesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_regions_tl
    #Irm::RegionsTl.where("language = ?", "en").each do |t|
    #  new_value = Irm::RegionsTl.new(t.attributes)
    #  new_value.language = "ja"
    #  new_value.save
    #end
    #irm_report_folders_tl
    Irm::ReportFoldersTl.where("language = ?", "en").each do |t|
      new_value = Irm::ReportFoldersTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_report_type_categories_tl
    Irm::ReportTypeCategoriesTl.where("language = ?", "en").each do |t|
      new_value = Irm::ReportTypeCategoriesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_report_types_tl
    Irm::ReportTypesTl.where("language = ?", "en").each do |t|
      new_value = Irm::ReportTypesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_reports_tl
    Irm::ReportsTl.where("language = ?", "en").each do |t|
      new_value = Irm::ReportsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_roles_tl
    Irm::RolesTl.where("language = ?", "en").each do |t|
      new_value = Irm::RolesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_rule_filters_tl
    Irm::RuleFiltersTl.where("language = ?", "en").each do |t|
      new_value = Irm::RuleFiltersTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_site_groups_tl
    #Irm::SiteGroupsTl.where("language = ?", "en").each do |t|
    #  new_value = Irm::SiteGroupsTl.new(t.attributes)
    #  new_value.language = "ja"
    #  new_value.save
    #end
    #irm_sites_tl
    #Irm::SitesTl.where("language = ?", "en").each do |t|
    #  new_value = Irm::SitesTl.new(t.attributes)
    #  new_value.language = "ja"
    #  new_value.save
    #end
    #irm_system_parameters_tl
    Irm::SystemParametersTl.where("language = ?", "en").each do |t|
      new_value = Irm::SystemParametersTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #irm_tabs_tl
    Irm::TabsTl.where("language = ?", "en").each do |t|
      new_value = Irm::TabsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #skm_channels_tl
    Skm::ChannelsTl.where("language = ?", "en").each do |t|
      new_value = Skm::ChannelsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #skm_columns_tl
    Skm::ColumnsTl.where("language = ?", "en").each do |t|
      new_value = Skm::ColumnsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #skm_entry_statuses_tl
    Skm::EntryStatusesTl.where("language = ?", "en").each do |t|
      new_value = Skm::EntryStatusesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #slm_calendars_tl
    Slm::CalendarsTl.where("language = ?", "en").each do |t|
      new_value = Slm::CalendarsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #slm_service_agreements_tl
    Slm::ServiceAgreementsTl.where("language = ?", "en").each do |t|
      new_value = Slm::ServiceAgreementsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #slm_service_catalogs_tl
    Slm::ServiceCatalogsTl.where("language = ?", "en").each do |t|
      new_value = Slm::ServiceCatalogsTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
    #slm_service_categories_tl
    Slm::ServiceCategoriesTl.where("language = ?", "en").each do |t|
      new_value = Slm::ServiceCategoriesTl.new(t.attributes)
      new_value.language = "ja"
      new_value.save
    end
  end

  def down
  end
end
