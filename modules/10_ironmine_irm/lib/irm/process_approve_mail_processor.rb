module Irm
  class ProcessApproveMailProcessor < Irm::MailManager::Processor
    def perform(email,parsed_email)
      puts  parsed_email
      # get the person
      person  = Irm::Person.unscoped.where(:email_address=>email.from_addrs.to_a.first).first
      return false unless person
      Irm::Person.current = person
      # get the parsed email
      # use the plain mail message content
      return false unless parsed_email[:bodies].size>0
      if parsed_email[:in_reply_to].present?
        # parse reference information
        source_infos = parsed_email[:in_reply_to].gsub(/@.*/,"").split(".")
        return false unless source_infos.size>4&&source_infos[0].eql?("ironmine")&&source_infos[1].start_with?("mailapproval")&&source_infos[2].camelize.eql?(Irm::WfStepInstance.name)
        # allow to mail approve
        approval_infos = source_infos[1].split("\/")
        return false unless approval_infos.size>1&&approval_infos[1].eql?("allow")
        # approval step instance
        step_instance = Irm::WfStepInstance.find(source_infos[3])
        # approve result
        content_lines = parsed_email[:bodies][0].lines.collect{|line| line}
        return false unless content_lines.size>0
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
        return true
      else
        return false
      end
      Irm::Person.current = nil
    end
  end
end