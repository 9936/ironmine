class UpgradeHtc < ActiveRecord::Migration
  def up
    opu = "001n00012i8IyyjJakd6Om"
    #get roles
    role_hea = Irm::Role.where("code = ?", "HEA").first
    role_she = Irm::Role.where("code = ?", "SHE").first
    role_shanghai = Irm::Role.where("code = ?", "HANDSHANGHAI").first
    role_singapore = Irm::Role.where("code = ?", "HANDSINGAPORE").first
    role_mito = Irm::Role.where("code = ?", "MITO").first
    role_hisys = Irm::Role.where("code = ?", "HISYS").first
    role_hisol = Irm::Role.where("code = ?", "HISOL").first

    #add role to existed person
    Irm::Person.all.each do |p|
      next unless p.role_id.blank?
      if p.email_address.include?("@hea.hitachi.com.sg")
        p.update_attribute(:role_id, role_hea.id)
      elsif p.email_address.include?("@siamihitachi.com")
        p.update_attribute(:role_id, role_she.id)
      elsif p.email_address.include?("@hitachi.com")
        p.update_attribute(:role_id, role_mito.id)
      elsif p.email_address.include?("hitachi-solutions.com")
        p.update_attribute(:role_id, role_hisol.id)
      elsif p.email_address.include?("@hitachi-systems.com")
        p.update_attribute(:role_id, role_hisys.id)
      elsif p.email_address.include?("@hand-china.com")
        p.update_attribute(:role_id, role_shanghai.id)
      elsif p.email_address.include?("@hand-sg.com")
        p.update_attribute(:role_id, role_singapore.id)
      end

    end
    project_user_profile = Irm::Profile.where("code = ?", "PROJECT_USER").first
    project_support_profile = Irm::Profile.where("code = ?", "PROJECT_SUPPORT").first
    project_admin_profile = Irm::Profile.where("code = ?", "PROJECT_ADMIN").first

    enduser_profile = Irm::Profile.where("code = ?", "ENDUSER").first
    pmo_profile = Irm::Profile.where("code = ?", "PMO").first
    admin_profile = Irm::Profile.where("code = ?", "OPUADMINISTRATOR").first
    support_profile = Irm::Profile.where("code = ?", "SUPPORT").first
    its_profile = Irm::Profile.where("code = ?", "ITS").first

    #add system profile to existed ava. person-system
    Irm::ExternalSystem.all.each do |e|
      e.owned_people.each do |op|
        es_member = Irm::ExternalSystemPerson.
            where("external_system_id = ?", e.id).
            where("person_id = ?", op.id).first
        next if es_member.system_profile_id.present?

        if op.profile_id.eql?(pmo_profile.id) ||
            op.profile_id.eql?(admin_profile.id) ||
            op.profile_id.eql?(support_profile.id) ||
            op.profile_id.eql?(its_profile.id)
          es_member.update_attribute(:system_profile_id, project_support_profile.id)
        elsif op.profile_id.eql?(enduser_profile.id)
          es_member.update_attribute(:system_profile_id, project_user_profile.id)
        end
      end
    end

    #using the new sequence identify by system(GSCM - A, GOE - B)
    #update all existed ticket number
    Icm::IncidentRequest.all.each do |r|
      r.update_attribute(:request_number, "A" + r.request_number)
    end

    #reset sequence A for GSCM
    gscm_sequence = Irm::Sequence.where("object_name=?","Icm::IncidentRequest").first
    gscm_sequence.update_attributes(:object_name => "GSCM", :rules => "A###sequence###")

    #create sequence B for GOE
    Irm::Sequence.create(:opu_id => opu,
                         :object_name => "GOE",
                         :seq_max => 0,
                         :seq_length => 5,
                         :seq_next => 1, :rules => "B###sequence###")
  end

  def down
  end
end
