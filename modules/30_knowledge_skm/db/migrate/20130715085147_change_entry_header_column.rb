class ChangeEntryHeaderColumn < ActiveRecord::Migration
  def change
    change_column_default(:skm_entry_headers, :project_id, '-1')

    Skm::EntryHeader.where("project_id is null").update_all(:project_id => "-1")
  end
end
