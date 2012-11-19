class AddDisplaySequenceToFilter < ActiveRecord::Migration
  def up
    add_column :irm_rule_filters, :display_sequence, :integer, :after => :opu_id, :default => 500
  end

  def down
    remove_column :irm_rule_filters, :display_sequence
  end
end
