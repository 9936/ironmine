class ChangeNdmOwnerToId < ActiveRecord::Migration
  def up
    change_column :ndm_dev_managements, "gd_owner", :string, :limit => 22, :collate => "utf8_bin"
    change_column :ndm_dev_managements, "fd_owner", :string, :limit => 22, :collate => "utf8_bin"
    change_column :ndm_dev_managements, "fdr_owner", :string, :limit => 22, :collate => "utf8_bin"
    change_column :ndm_dev_managements, "td_owner", :string, :limit => 22, :collate => "utf8_bin"
    change_column :ndm_dev_managements, "co_owner", :string, :limit => 22, :collate => "utf8_bin"
    change_column :ndm_dev_managements, "te_owner", :string, :limit => 22, :collate => "utf8_bin"
    change_column :ndm_dev_managements, "si_owner", :string, :limit => 22, :collate => "utf8_bin"
    change_column :ndm_dev_managements, "at_owner", :string, :limit => 22, :collate => "utf8_bin"
    change_column :ndm_dev_managements, "go_owner", :string, :limit => 22, :collate => "utf8_bin"
  end

  def down
  end
end
