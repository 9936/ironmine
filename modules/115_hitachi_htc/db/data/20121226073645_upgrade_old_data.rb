class UpgradeOldData < ActiveRecord::Migration
  def up
    opu = "001n00012i8IyyjJakd6Om"
    resolved_reason = Icm::CloseReason.where("close_code = ?", "RESOLVED").first
    goe = Irm::ExternalSystem.where("external_system_code = ?","GOE").first
    gscm = Irm::ExternalSystem.where("external_system_code = ?", "GSCM").first

    project_user_profile = Irm::Profile.where("code = ?", "PROJECT_USER").first
    project_support_profile = Irm::Profile.where("code = ?", "PROJECT_SUPPORT").first
    project_admin_profile = Irm::Profile.where("code = ?", "PROJECT_ADMIN").first

    enduser_profile = Irm::Profile.where("code = ?", "ENDUSER").first
    pmo_profile = Irm::Profile.where("code = ?", "PMO").first
    admin_profile = Irm::Profile.where("code = ?", "OPUADMINISTRATOR").first
    support_profile = Irm::Profile.where("code = ?", "SUPPORT").first
    its_profile = Irm::Profile.where("code = ?", "ITS").first

    Icm::IncidentRequest.
        joins(",icm_close_reasons_vl icr").
        where("icr.language=?", "en").
        select("#{Icm::IncidentRequest.table_name}.*, icr.name icr_name").
        where("icr.id = #{Icm::IncidentRequest.table_name}.close_reason_id").
        each do |ir|
      ir.update_attribute(:attribute1, ir[:icr_name])
      ir.update_attribute(:close_reason_id, resolved_reason.id)
    end

    Icm::IncidentRequest.all.each do |ir|
      ir.update_attribute(:attribute2, "HEA")
    end

    Irm::Person.all.each do |p|
      next unless p.auth_source_id.present?
      goe_exist = Irm::ExternalSystemPerson.
          where("person_id=?", p.id).
          where("external_system_id=?", goe.id)
      next if goe_exist.any?

      if p.profile_id.eql?(pmo_profile.id) ||
          p.profile_id.eql?(admin_profile.id) ||
          p.profile_id.eql?(support_profile.id) ||
          p.profile_id.eql?(its_profile.id)
        Irm::ExternalSystemPerson.create(:opu_id => opu,
                                         :external_system_id => goe.id,
                                         :system_profile_id => project_support_profile.id,
                                         :person_id => p.id)
      elsif p.profile_id.eql?(enduser_profile.id)
        Irm::ExternalSystemPerson.create(:opu_id => opu,
                                         :external_system_id => goe.id,
                                         :system_profile_id => project_user_profile.id,
                                         :person_id => p.id)
      end
    end
  end

  def down

  end
end
