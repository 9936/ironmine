module Ysq::SupportGroupsControllerEx
  def self.included(base)
    base.class_eval do
      def get_two_group_options
        if allow_to_function?(:assign_two_group_by_user)
          support_groups_scope = Icm::SupportGroup.enabled.oncall.with_group(I18n.locale).with_system(params[:external_system_id]).where("irm_groups_vl.name in ('Help Desk', 'Deployment Team')").select_all
          support_groups = support_groups_scope.collect{|p| {:label=>p[:name],:value=>p[:id]}}
        else
          support_groups = []
        end
        respond_to do |format|
          format.json {render :json=>support_groups.to_grid_json([:label,:value],support_groups.count)}
        end
      end
    end
  end
end
