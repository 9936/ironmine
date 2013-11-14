module Amo::RatingModelEx
  def self.included(base)
    base.class_eval do
      #after_create :trigger_survey

      def trigger_survey
        if false && self.bo_name.eql?("Icm::IncidentRequest")
          #将事故单的状态进行修改
          incident_request = Icm::IncidentRequest.find(self.rating_object_id)
          incident_request.incident_status_id = Icm::IncidentStatus.transform(incident_request.incident_status_id, "RATING", incident_request.external_system_id)
          incident_request.save

          #当评价对象为事故单，且评分小于6分给支持人员触发调查问卷
          if self.grade.to_i < 6
            #邮件通知
            Delayed::Job.enqueue(Amo::Jobs::RatingJob.new(incident_request.id))
            #创建调查问卷
            Delayed::Job.enqueue(Icm::Jobs::IncidentRequestSurveyTaskJob.new(incident_request.id))
          end
        end

      end
    end
  end
end