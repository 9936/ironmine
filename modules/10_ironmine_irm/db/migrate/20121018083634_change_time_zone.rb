class ChangeTimeZone < ActiveRecord::Migration
  def up
    remove_column :irm_people, :time_zone_code
    add_column :irm_people, :time_zone, :string, :default => "Beijing", :after => "language_code"
  end

  def down
    remove_column :irm_people, :time_zone
    add_column :irm_people, :time_zone_code, :string, :default => "GMT_P0800_4", :after => "language_code"
  end
end
