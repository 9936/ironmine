class Irm::WfApprovalSubmitter < ActiveRecord::Base
  set_table_name :irm_wf_approval_submitters

  belongs_to :wf_approval_process,:foreign_key => :process_id

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}


  attr_accessor :bo_code

  scope :bo_attribute,lambda{|process_id|
    where(:process_id=>process_id,:submitter_type=>Irm::BusinessObject.class_name_to_code(Irm::ObjectAttribute.name))
  }

  def person_ids(bo)
    person_ids = []
    case self.submitter_type
      when Irm::BusinessObject.class_name_to_code(Irm::ObjectAttribute.name)
        if bo
          value = Irm::BusinessObject.attribute_of(bo,self.submitter_id)
          if value.present?
            if value.is_a?(Array)
              person_ids = value
            else
              person_ids = [value.to_i]
            end
          end
        end
    end
    person_ids
  end


  def include_person?(s_id,bo_instance)
    case self.submitter_type
      when Irm::BusinessObject.class_name_to_code(Irm::ObjectAttribute.name)
        if bo_instance
          value = Irm::BusinessObject.attribute_of(bo_instance,self.submitter_id)
          if value.present?
            if value.is_a?(Array)
              return value.include?(s_id)
            else
              return s_id.eql?(value)
            end
          end
        end
    end
    return false
  end

end
