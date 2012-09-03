class AddTypeToSkmHeader < ActiveRecord::Migration
  def up
    add_column :skm_entry_headers, :type_code, :string, :limit => 30, :after => :source_id
  end

  def down
    remove_column :skm_entry_headers, :type_code
  end
end
