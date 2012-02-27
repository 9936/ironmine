module Irm
  class ProcessMailJournalProcessor < Irm::MailManager::Processor
    def perform(email,parsed_email)
      # get the person
      person  = Irm::Person.unscoped.where(:email_address=>email.from_addrs.to_a.first).first
      return false unless person
      Irm::Person.current = person
      if email.in_reply_to.present? && email.in_reply_to.index("icm/incident_journal")
        source_journal = Icm::IncidentJournal.find(email.in_reply_to.split('.')[3])
        incident_request = source_journal.incident_request
        #如果非watcher，或者事故单已经关闭，则不创建回复
        return false unless source_journal.watcher_person_ids.include?(person.id)
        return false if incident_request.close?

        incident_journal = Icm::IncidentJournal.new()
        incident_journal.replied_by=Irm::Person.current.id
        content = parsed_email[:bodies][1]
        return false unless content.size>0

        incident_journal.message_body = "<pre>" + content + "</pre>"
        incident_journal.incident_request_id = incident_request.id

        # 设置回复类型
        # 1,客户回复
        # 2,服务台回复
        # 3,其他人员回复
        if Irm::Person.current.id.eql?(incident_request.requested_by)
          incident_journal.reply_type = "CUSTOMER_REPLY"
        elsif Irm::Person.current.id.eql?(incident_request.support_person_id)
          incident_journal.reply_type = "SUPPORTER_REPLY"
        else
          incident_journal.reply_type = "OTHER_REPLY"
        end

        if incident_journal.save
          return true
        else
          return false
        end
      elsif email.in_reply_to.present? && email.in_reply_to.index("icm/incident_request")
        incident_request = Icm::IncidentRequest.find(email.in_reply_to.split('.')[3])
        #如果非watcher，或者事故单已经关闭，则不创建回复
        return false unless incident_request.watcher_person_ids.include?(person.id)
        return false if incident_request.close?
        incident_journal = Icm::IncidentJournal.new()
        incident_journal.replied_by=Irm::Person.current.id

        content = parsed_email[:bodies][0]
        return false unless content.size>0

        incident_journal.message_body = "<pre>" + content + "</pre>"
        incident_journal.incident_request_id = incident_request.id
        # 设置回复类型
        # 1,客户回复
        # 2,服务台回复
        # 3,其他人员回复
        if Irm::Person.current.id.eql?(incident_request.requested_by)
          incident_journal.reply_type = "CUSTOMER_REPLY"
        elsif Irm::Person.current.id.eql?(incident_request.support_person_id)
          incident_journal.reply_type = "SUPPORTER_REPLY"
        else
          incident_journal.reply_type = "OTHER_REPLY"
        end
        if incident_journal.save
          return true
        else
          return false
        end
      else
        false
      end
    rescue Exception => exc
      puts "++++++++++++++++ rescue" + exc.message
      false
    end
  end
end