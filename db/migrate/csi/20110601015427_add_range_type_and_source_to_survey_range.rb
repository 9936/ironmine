class AddRangeTypeAndSourceToSurveyRange < ActiveRecord::Migration
  def self.up
    add_column :csi_survey_ranges, :source_type, :string, :limit => 30, :after => :survey_id
    add_column :csi_survey_ranges, :source_id, :integer, :after => :survey_id
  end

  def self.down
    remove_column :csi_survey_ranges, :source_type
    remove_column :csi_survey_ranges, :source_id
  end
end
