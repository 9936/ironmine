class Irm::Railtie < Rails::Railtie

  # subscribe receive mail event and process approval email
  ActiveSupport::Notifications.subscribe do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    if event.name.eql?("mail.receive")
      # get the person
      person  = Irm::Person.where(:email_address=>event.payload[:email].from_addrs.to_a.first).first
      break unless person
      # get the parsed email
      # use the plain mail message content
      parsed_email = event.payload[:parsed_email]
      break unless parsed_email[:bodies].size>0
      if parsed_email[:in_reply_to].present?
        # parse reference information
        source_infos = parsed_email[:in_reply_to].gsub(/@.*/,"").split(".")
        break unless source_infos.size>4&&source_infos[0].eql?("ironmine")&&source_infos[1].start_with?("mailapproval")&&source_infos[2].camelize.eql?(Irm::WfStepInstance.name)
        # allow to mail approve
        approval_infos = source_infos[1].split("\/")
        break unless approval_infos.size>1&&approval_infos[1].eql?("allow")
        # approval step instance
        step_instance = Irm::WfStepInstance.find(source_infos[3])
        # approve result
        content_lines = parsed_email[:bodies][0].lines.collect{|line| line}
        break unless content_lines.size>0
        approve_result = content_lines[0].strip
        step_instance.comment = content_lines[1]||""
        # execute approve
        Irm::WfStepInstance.transaction do
          case  approve_result
            when "REJECT"
              step_instance.reject(person.id)
            when "APPROVED"
              step_instance.approved(person.id)
          end
        end
      end
    end
  end
end