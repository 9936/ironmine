class ReworkIncidentRquestOrganization < ActiveRecord::Migration
  def self.up
    first_requester = Irm::Person.select_all.with_profile.where("pv.user_license = ?","REQUESTER").first
    Icm::IncidentRequest.all.each do |irq|
      if irq.requested_by.present?
        requester = Irm::Person.query(irq.requested_by).first
        if requester
          irq.organization_id =  requester.organization_id
        else
          irq.requested_by  = first_requester.id
          irq.organization_id =  first_requester.organization_id
        end
      else
        irq.requested_by = first_requester.id
        irq.organization_id =  first_requester.organization_id
      end
      irq.save
    end
  end

  def self.down
  end
end
