class Irm::Railtie < Rails::Railtie
  # subscribe receive mail event and process approval email
  ActiveSupport::Notifications.subscribe do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    if event.name.eql?("mail.receive")

      parsed_email = event.payload[:parsed_email]
      break unless parsed_email[:bodies].size>0
      if parsed_email[:in_reply_to].present?
        source_infos = parsed_email[:in_reply_to].gsub(/@.*/,"").split(".")
        break unless source_infos.size>4&&source_infos[0].eql?("ironmine")&&source_infos[1].start_with?("mailapproval")&&source_infos[2].camelize.eql?(Irm::WfStepInstance.name)
        approval_infos = source_infos[1].split("\/")
        break unless approval_infos.size>1&&approval_infos[1].eql?("allow")
        step_instance = Irm::WfStepInstance.find(source_infos[3])
        content_lines = parsed_email[:bodies][0].lines.collect{|line| line}
        break unless content_lines.size>0
        approve_result = content_lines[0].strip
        step_instance.comment = approve_result[1]||""
        case  approve_result
          when "REJECT"
            step_instance.reject(Irm::Person.current.id)
          when "APPROVED"
            step_instance.approved(Irm::Person.current.id)
        end
      end
    end
  end
end