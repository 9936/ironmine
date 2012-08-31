class AddRelationIdToSkmHeader < ActiveRecord::Migration
  def up
    add_column :skm_entry_headers, :relation_id, :string, :limit => 22, :after => :type_code
  end

  def down
    remove_column :skm_entry_headers, :relation_id
  end
end
