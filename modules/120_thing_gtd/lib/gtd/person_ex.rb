module Gtd::PersonEx
  def self.included(base)
    base.class_eval do
      # task assign LOV额外处理方法
      def self.task_assign_lov(lov_scope, params)

        if params[:lov_params].present?&&params[:lov_params].is_a?(Hash)&&params[:lov_params][:lktkn].present?

          #根据lov进行不同的处理
          if "person_from".eql?(params[:lov_params][:lktkn])&&params[:lov_params][:task_assign_id].present?
            task_assign = Gtd::TaskAssign.find(params[:lov_params][:task_assign_id])

            lov_scope = self.joins(",#{Irm::ExternalSystemPerson.table_name} esp ")
                            .where("esp.external_system_id = ?", task_assign.external_system_id)
                            .where("esp.person_id = #{table_name}.id")
                            .where("NOT EXISTS(SELECT 1 FROM #{Gtd::TaskAssignMember.table_name} WHERE #{Gtd::TaskAssignMember.table_name}.person_id = #{table_name}.id AND #{Gtd::TaskAssignMember.table_name}.task_assign_id = ?) ",task_assign.id)
                            .where("#{table_name}.full_name like ? ",params[:search])

          elsif "person_to".eql?(params[:lov_params][:lktkn])&&params[:lov_params][:task_assign_id].present?
            lov_scope = self.joins(",#{Irm::ExternalSystemPerson.table_name} esp ")
                                        .where("esp.external_system_id = ?", params[:lov_params][:external_system_id])
                                        .where("esp.person_id = #{table_name}.id")
                                        .where("NOT EXISTS(SELECT 1 FROM #{Gtd::TaskAssignMember.table_name} WHERE #{Gtd::TaskAssignMember.table_name}.person_id = #{table_name}.id AND #{Gtd::TaskAssignMember.table_name}.task_assign_id = ?) ",task_assign.id)
                                        .where("#{table_name}.full_name like ? ",params[:search])
          end
        end
        lov_scope
      end

      scope :query_task_assign,lambda{|task_assign_id,type|
        joins("JOIN #{Gtd::TaskAssignMember.table_name} ON #{Gtd::TaskAssignMember.table_name}.person_id = #{table_name}.id AND #{Gtd::TaskAssignMember.table_name}.task_assign_id = '#{task_assign_id}' AND #{Gtd::TaskAssignMember.table_name}.member_type = '#{type}'" )
      }

    end
  end
end