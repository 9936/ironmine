module Yan::ExternalSystemHelperEx
  def self.included(base)
    base.class_eval do
      #GPACK-DEV,GPACK-YA DEV, GPACK-YADIN DEV, GPACK-YID DEV
      def dev_sys
        systems = Irm::ExternalSystem.multilingual.order_with_name.with_dev_sys.enabled
        systems.collect{|p| [p[:system_name], p.id]}
      end

      def ava_categories
        category_options = []
        category_options << ["--- #{t(:actionview_instancetag_blank_option)} ---",""]
        category_options += Icm::IncidentCategory.enabled.multilingual.collect{|i|[i[:name],i.id]}
        category_options
      end

      def ava_statuses
        category_options = []
        category_options << ["--- #{t(:actionview_instancetag_blank_option)} ---",""]
        category_options += Icm::IncidentStatus.enabled.multilingual.order("display_sequence ASC").collect{|i|[i[:name],i.id]}
        category_options
      end

      def available_priority_for_report
        options = []
        options << ["--- #{t(:actionview_instancetag_blank_option)} ---",""]
        options += Icm::PriorityCode.multilingual.where("priority_code in ('GRADE_1','GRADE_2','GRADE_3','GRADE_4')").collect{|i|[i[:name],i.id]}
        options
      end

      def ava_groups
        group_options = []
        group_options << ["--- #{t(:actionview_instancetag_blank_option)} ---",""]
        group_options += Icm::SupportGroup.with_groups(I18n.locale).enabled.where("icm_support_groups.oncall_flag = 'Y'").select("irm_groups_vl.name name,icm_support_groups.id id").collect{|i|[i[:name],i.id]}
        group_options
      end

    end
  end
end