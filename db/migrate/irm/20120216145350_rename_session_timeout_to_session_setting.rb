class RenameSessionTimeoutToSessionSetting < ActiveRecord::Migration
  def up
    rename_table :irm_session_timeouts, :irm_session_settings
  end

  def down
    rename_table :irm_session_settings,  :irm_session_timeouts
  end
end
