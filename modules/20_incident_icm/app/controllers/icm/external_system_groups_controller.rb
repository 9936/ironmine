class Icm::ExternalSystemGroupsController < ApplicationController
  def add_groups
    external_system_group = Icm::ExternalSystemGroup.new(params[:icm_external_system_group])
    respond_to do |format|
      if(!external_system_group.status_code.blank?)
        external_system_group.status_code.split(",").delete_if{|i| i.blank?}.each do |id|
          Icm::ExternalSystemGroup.create(:external_system_id => params[:external_system_id],:support_group_id => id)
        end
      end
      format.html { redirect_to({:controller => "irm/external_systems",:action=>"show", :id => params[:external_system_id]}, :notice => t(:successfully_created)) }
    end
  end

  def delete_groups
    external_system_group = Icm::ExternalSystemGroup.new(params[:icm_external_system_group])

    respond_to do |format|
      if(!external_system_group.temp_group_ids.blank?)
        external_system_group.temp_group_ids.split(",").delete_if{|i| i.blank?}.each do |id|
          esg = Icm::ExternalSystemGroup.where(:external_system_id => params[:external_system_id],:id => id).first
          esg.destroy if esg
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