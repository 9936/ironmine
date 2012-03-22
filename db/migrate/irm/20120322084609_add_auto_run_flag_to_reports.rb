class AddAutoRunFlagToReports < ActiveRecord::Migration
  def change
    add_column :irm_reports, "auto_run_flag", :string,:limit => 1, :null => false,:default=>"N",:after => "detail_display_flag"
  end
end
