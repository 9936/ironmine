class RemoveOldRangColumnFromSurveyRange < ActiveRecord::Migration
  def self.up
    remove_column :csi_survey_ranges, :range_type
    remove_column :csi_survey_ranges, :range_company_id
    remove_column :csi_survey_ranges, :range_department_id
    remove_column :csi_survey_ranges, :range_organization_id
    remove_column :csi_survey_ranges, :role_id
    remove_column :csi_survey_ranges, :site_id
  end

  def self.down
    add_column :csi_survey_ranges, :range_type, :string, :limit => 30
    add_column :csi_survey_ranges, :range_company_id, :integer
    add_column :csi_survey_ranges, :range_department_id, :integer
    add_column :csi_survey_ranges, :range_organization_id, :integer
    add_column :csi_survey_ranges, :role_id, :integer
    add_column :csi_survey_ranges, :site_id, :integer
  end
end
