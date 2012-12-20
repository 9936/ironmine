class AddDisplaySequenceToCategory < ActiveRecord::Migration
  def change
    add_column :icm_incident_categories, :display_sequence, :integer, :after => :opu_id, :default => 500
    add_column :icm_incident_sub_categories, :display_sequence, :integer, :after => :opu_id, :default => 500
  end
end
