class AddTimeZoneToPeople < ActiveRecord::Migration
  def change
    add_column :irm_people, :time_zone_code, :string, :default => "GMT_P0800_4", :after => "language_code"
  end
end
