module Yan::MasterStatusModelEx
  def self.included(base)
    base.class_eval do

      scope :master_history, lambda{
            joins("LEFT OUTER JOIN #{Irm::Person.table_name} ip1 ON ip1.id = #{table_name}.submitted_by").
            joins("LEFT OUTER JOIN #{Irm::Person.table_name} ip2 ON ip2.id = #{table_name}.support_person_id").
            joins("LEFT OUTER JOIN #{Icm::SupportGroup.table_name} isg ON isg.id = #{table_name}.support_group_id").
            joins("LEFT OUTER JOIN #{Irm::GroupsTl.table_name} igt ON igt.group_id = isg.group_id AND igt.language='en' ").
            joins("LEFT OUTER JOIN #{Mam::Master.table_name} mm ON mm.master_number = #{table_name}.master_number").
            joins("LEFT OUTER JOIN (select * from mam_master_replies where (master_id,created_at) in
                              (select master_id,max(created_at) created_at from mam_master_replies group by master_id) order by master_id)
                                     mmr ON mmr.master_id = mm.id").
            select("#{table_name}.*,DATE_FORMAT(mam_master_statuses.updated_at,'%Y-%m-%d %h:%i:%s') mm_updated_at, ip1.full_name submit,ip2.full_name supportp,igt.name supportg,DATE_FORMAT(mm.created_at,'%Y-%m-%d %h:%i:%s') ticket_created,DATE_FORMAT(mmr.created_at,'%Y-%m-%d %h:%i:%s') last_response")
                           }

    end
  end
end