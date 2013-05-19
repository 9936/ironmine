class CreateGtdTaskAssigns < ActiveRecord::Migration
  def change
    execute("CREATE OR REPLACE VIEW gtd_task_assign_explosions_v AS SELECT t.person_id,tl.person_id assign_person_id
                 FROM irm_group_members t,irm_group_members tl
                 WHERE t.group_id = tl.group_id and t.admin_flag= 'Y'
                 group by  t.person_id,tl.person_id")
    
  end
end
