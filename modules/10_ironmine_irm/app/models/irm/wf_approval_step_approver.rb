class Irm::WfApprovalStepApprover < ActiveRecord::Base
  set_table_name :irm_wf_approval_step_approvers

  belongs_to :wf_approval_step,:foreign_key => :step_id


  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}
  
  attr_accessor :bo_code

  scope :query_person_ids,lambda{
    joins("JOIN #{Irm::Person.relation_view_name} ON  #{Irm::Person.relation_view_name}.source_type = #{table_name}.approver_type AND #{Irm::Person.relation_view_name}.source_id = #{table_name}.approver_id").
        select("#{Irm::Person.relation_view_name}.person_id")
  }

  scope :bo_attribute,lambda{|step_id|
    where(:step_id=>step_id,:approver_type=>Irm::BusinessObject.class_name_to_code(Irm::ObjectAttribute.name))
  }

  def self.approver_types
    return @approver_types if @approver_types
    @approver_types = Irm::LookupValue.query_by_lookup_type("WF_MAIL_ALERT_RECIPIENT_TYPE").multilingual.order_id.collect{|p|[p[:meaning],p[:lookup_code]]}
  end


  def person_ids(bo=nil)
    person_ids = []
    case self.approver_type
      when Irm::BusinessObject.class_name_to_code(Irm::ObjectAttribute.name)
        if bo
          value = Irm::BusinessObject.attribute_of(bo,self.approver_id)
          if value.present?
            if value.is_a?(Array)
              person_ids = value
            else
              person_ids = [value]
            end
          end
        end
    end
    person_ids
  end
end
