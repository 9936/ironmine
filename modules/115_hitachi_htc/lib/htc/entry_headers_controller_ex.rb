module Htc::EntryHeadersControllerEx
  def self.included(base)
    base.class_eval do

      def approve_knowledge
        entry_header_id = params[:skm_entry_approval_person][:entry_header_id]
        if entry_header_id
          entry_approval_person = Skm::EntryApprovalPerson.where("person_id=? AND entry_header_id=?", Irm::Person.current.id, entry_header_id).first
          if params[:commit].eql?(I18n.t(:label_skm_entry_header_button_ok))
            params[:skm_entry_approval_person][:approval_flag] = Irm::Constant::SYS_YES
            entry_approval_person.update_attributes(params[:skm_entry_approval_person])
            #unless Skm::EntryApprovalPerson.has_unaudited_person?(entry_header_id)
              Skm::EntryHeader.find(entry_header_id).update_attribute(:entry_status_code,Skm::EntryStatus::PUBLISHED) #更新为发布状态
            #end
          else
            params[:skm_entry_approval_person][:approval_flag] = Skm::EntryStatus::SYS_REFUSE
            entry_approval_person.update_attributes(params[:skm_entry_approval_person])
            Skm::EntryHeader.find(entry_header_id).update_attribute(:entry_status_code, Skm::EntryStatus::APPROVE_DENY)   #更新为审核拒绝状态
          end
        end
        respond_to do |format|
          format.html { redirect_to :action => "wait_my_approve" }
        end
      end

    end
  end
end