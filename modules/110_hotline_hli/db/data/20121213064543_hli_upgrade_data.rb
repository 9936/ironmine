class HliUpgradeData < ActiveRecord::Migration
  def up
    opu = Irm::OperationUnit.where("short_name = ?", "Hand").first.id

    #根据code，建立support group与external system的关联
    Irm::ExternalSystem.where("1=1").enabled.each do |es|
      Irm::Group.where("code = ?", es.external_system_code).each do |gp|
        Icm::SupportGroup.where("group_id = ?", gp.id).each do |sg|
          group_system = Icm::ExternalSystemGroup.new(:opu_id => opu,
                                                      :external_system_id => es.id,
                                                      :support_group_id => sg.id)
        end
      end
    end

    #给项目人员分配默认的system profile
    user_profile = Irm::Profile.where("code = ?", "PROJECT_USER").first
    helpdesk_profile = Irm::Profile.where("code = ?", "PROJECT_HELPDESK").first
    manager_profile = Irm::Profile.where("code = ?", "PROJECT_MANAGER").first

    #汉得员工，都赋予运维人员角色
    Irm::ExternalSystemPerson.
        select("#{Irm::ExternalSystemPerson.table_name}.*").
        select("pe.email_address email_address").
        joins(",#{Irm::Person.table_name} pe").
        where("pe.id = #{Irm::ExternalSystemPerson.table_name}.person_id").each do |esp|
      if esp[:email_address].include?("hand-china.com")
        esp.update_attribute(:system_profile_id, helpdesk_profile.id)
      else
        esp.update_attribute(:system_profile_id, user_profile.id)
      end
    end
  end

  def down
  end
end
