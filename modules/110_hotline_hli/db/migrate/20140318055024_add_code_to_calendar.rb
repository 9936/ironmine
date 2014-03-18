class AddCodeToCalendar < ActiveRecord::Migration
  def change
    add_column :slm_calendars , :code, :string,:before=>:status_code
    add_column :slm_calendars,:master_code,:string,:after=>:code
  end
end
