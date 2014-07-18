class FixPeopleProfile < ActiveRecord::Migration
  def up
    execute("UPDATE irm_people SET profile_id = '001z00012i8IyyjJaqK4AK' WHERE email_address LIKE '%hand-china.com' AND login_name NOT IN ('ironmine', 'anonymous')")
  end

  def down
  end
end
