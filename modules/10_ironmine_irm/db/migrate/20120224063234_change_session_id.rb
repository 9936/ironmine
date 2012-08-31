class ChangeSessionId < ActiveRecord::Migration
  def change
    change_column :irm_session_settings, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end
end
