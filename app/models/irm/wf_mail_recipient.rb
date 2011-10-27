class Irm::WfMailRecipient < ActiveRecord::Base
  set_table_name :irm_wf_mail_recipients

  belongs_to :wf_mail_alert

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  attr_accessor :bo_code


 scope :query_person_ids,lambda{
    joins("JOIN #{Irm::Person.relation_view_name} ON  #{Irm::Person.relation_view_name}.source_type = #{table_name}.recipient_type AND #{Irm::Person.relation_view_name}.source_id = #{table_name}.recipient_id").
        select("#{Irm::Person.relation_view_name}.person_id")
  }

  scope :bo_attribute,lambda{|wf_mail_alert_id|
    where(:wf_mail_alert_id=>wf_mail_alert_id,:recipient_type=>Irm::BusinessObject.class_name_to_code(Irm::ObjectAttribute.name))
  }


  def person_ids(bo=nil)
    person_ids = []
    case self.recipient_type
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
