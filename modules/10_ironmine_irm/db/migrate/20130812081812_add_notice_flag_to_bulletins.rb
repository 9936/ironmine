class AddNoticeFlagToBulletins < ActiveRecord::Migration
  def change
    add_column :irm_bulletins, :notice_flag, :string, :limit => 1, :default => 'N', :after => 'highlight_flag', :null => false
  end
end
