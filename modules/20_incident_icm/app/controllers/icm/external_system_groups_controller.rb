class Icm::ExternalSystemGroupsController < ApplicationController
  def add_groups
    external_system_group = Icm::ExternalSystemGroup.new(params[:icm_external_system_group])
    respond_to do |format|
      if external_system_group.status_code.present?
        external_system_group.status_code.split(",").delete_if{|i| i.blank?}.each do |id|
          Icm::ExternalSystemGroup.create(:external_system_id => params[:external_system_id],:support_group_id => id)
          #同步支持组中的人员
          if params[:merge_people] and params[:merge_people].eql?("Y") and params[:default_system_profile].present?
            members = Irm::GroupMember.query_by_support_group(id)
            members.each do |member|
              Irm::ExternalSystemPerson.create(:external_system_id => params[:external_system_id],
                                               :person_id => member.person_id,
                                               :system_profile_id => params[:default_system_profile] )
            end if members.any?
          end
        end
      end
      format.html { redirect_to({:controller => "irm/external_systems",:action=>"show", :id => params[:external_system_id]}, :notice => t(:successfully_created)) }
    end
  end

  def delete_groups
    external_system_group = Icm::ExternalSystemGroup.new(params[:icm_external_system_group])

    respond_to do |format|
      if external_system_group.temp_group_ids.present?
        external_system_group.temp_group_ids.split(",").delete_if{|i| i.blank?}.each do |id|
          esg = Icm::ExternalSystemGroup.where(:external_system_id => params[:external_system_id],:id => id).first

          #删除支持组下在该系统中的人员
          if esg and params[:delete_people] and params[:delete_people].eql?('Y')
            members = Irm::GroupMember.query_by_support_group(esg.support_group_id)
            #检查人员是否还在该系统的其他支持组内
            members.each do |member|
              #查找该人员所在的支持组
              system_groups = Icm::ExternalSystemGroup.query_by_sp(params[:external_system_id], member.person_id)

              if system_groups.any? and system_groups.size == 1
                person = Irm::ExternalSystemPerson.where("external_system_id=? AND person_id=?", params[:external_system_id], member.person_id).first
                if person.present?
                  person.destroy
                end
              end
            end
            esg.destroy
          end
        end
      end
      format.html { redirect_to({:controller => "irm/external_systems",:action=>"show", :id => params[:external_system_id]}) }
    end
  end

  def get_owned_groups_data
    system_id = params[:external_system_id]

    system_group_scope = Icm::ExternalSystemGroup.with_groups(I18n.locale).with_system(system_id)
    system_group_scope = system_group_scope.match_value("#{Irm::Group.view_name}.name ", params[:group_name]) if params[:group_name]
    system_groups,count = paginate(system_group_scope)
    respond_to do |format|
      format.html  {
        @datas = system_groups
        @count = count
      }
    end
  end

  def get_available_groups_data
    system_id = params[:external_system_id]
    group_name = params[:group_id]
    system_group_scope = Icm::SupportGroup.with_groups(I18n.locale).without_system(system_id)
    system_group_scope = system_group_scope.match_value("#{Irm::Group.view_name}.name ",group_name) if group_name
    system_groups,count = paginate(system_group_scope)
    respond_to do |format|
      format.html  {
        @datas = system_groups
        @count = count
      }
    end
  end
end