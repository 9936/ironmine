class AddParamFlagIrmReportCriterions < ActiveRecord::Migration
  def up
    add_column :irm_report_criterions,:param_flag,:string,:limit=>1,:default=>"N",:after=>:field_id
  end

  def down
    remove_column :irm_report_criterions,:param_flag
  end
end
