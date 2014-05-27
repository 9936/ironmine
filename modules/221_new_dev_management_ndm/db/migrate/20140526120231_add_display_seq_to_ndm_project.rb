class AddDisplaySeqToNdmProject < ActiveRecord::Migration
  def change
    add_column :ndm_projects, :display_sequence, :integer, :default => 500, :null => false
  end
end
