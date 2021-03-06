module Icm
  module Jobs
    class IncidentRequestSurveyTaskJob < Struct.new(:incident_request_id)
      def perform

        # 取得调查问卷关联的事故单
        request = Icm::IncidentRequest.unscoped.find(incident_request_id)

        # 设置运行的当前人员
        Irm::Person.current = Irm::Person.find(request.requested_by)


        surveys = Csi::Survey.where("close_date IS NULL OR close_date > ?", Time.now).
            where("incident_flag = ?", Irm::Constant::SYS_YES).enabled


        Delayed::Worker.logger.debug("IncidentRequestSurveyTaskJob Find  surveys #{surveys.size}")

        person = Irm::Person.find(request.requested_by)


        surveys.each do |sv|
          Delayed::Worker.logger.debug("IncidentRequestSurveyTaskJob Detect #{sv.id}")
          next if Csi::SurveyMember.where(:survey_id=>sv.id,:person_id=>person.id,:source_id=>request.id,:source_type=>request.class.name).first
          Delayed::Worker.logger.debug("IncidentRequestSurveyTaskJob Execute #{sv.id}")

          person_ids = []

          srr = nil

          Csi::SurveyRange.where(:survey_id=>sv.id).each do |sr|
            person_ids = person_ids + Csi::SurveyRange.where(:survey_id=>sr.survey_id).query_person_ids.collect{|i| i[:person_id]}
            if person_ids.include?(person.id)
              srr = sr
              break
            end
            Delayed::Worker.logger.debug("IncidentRequestSurveyTaskJob Find survey rang:#{sr.id} person ids:#{person_ids} current person #{person.id} ====#{person_ids.include?(person.id)}")
          end

          next unless person_ids.include?(person.id)

          sm = Csi::SurveyMember.where(:survey_id=>sv.id,:person_id=>person.id,:source_id=>request.id,:source_type=>request.class.name)

          if sm.any?
            Delayed::Worker.logger.debug("IncidentRequestSurveyTaskJob update survey member #{sm.id}")
            sm.each do |s|
              s.update_attributes(:required_flag=>srr.required_flag,:end_date_active => sv.close_date) if sm
            end
          else
            sm = Csi::SurveyMember.create(:survey_id=>sv.id,:person_id=>person.id,:required_flag => srr.required_flag,
                                        :response_flag=>Irm::Constant::SYS_NO,:end_date_active => sv.close_date,
                                        :source_id=>request.id,:source_type=>request.class.name)
            Delayed::Worker.logger.debug("IncidentRequestSurveyTaskJob create survey member #{sm.id}")
          end
        end
      end
    end
  end
end