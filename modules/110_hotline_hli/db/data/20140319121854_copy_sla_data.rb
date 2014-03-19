class CopySlaData < ActiveRecord::Migration
  def up
    #source project
    source_project = Irm::ExternalSystem.where("external_system_code = ?", 10247)
    if source_project.any?
      source_project = source_project.first
    else
      puts("+++++++++running false")
      return false
    end

    hotline_projects = Irm::ExternalSystem.where("hotline_flag = 'Y'").where("id <> ?", source_project.id)

    #source calendar
    source_calendars = Slm::Calendar.where("external_system_id = ?", source_project.id)

    #source agreements
    source_agreements = Slm::ServiceAgreement.where("external_system_id = ?", source_project.id).enabled
    puts("+++++++++start copy")
    #starting copy
    hotline_projects.each do |hp|
      #copy calendar、calendar items
      source_calendars.each do |sc|
        t_sc = sc.attributes
        t_sc.delete("id")
        t = Slm::Calendar.new(t_sc.merge({:not_auto_mult=>true}))
        t.external_system_id = source_project.id
        sc.calendars_tls.each do |sct|
          sct_attributes = sct.attributes
          sct_attributes.delete("id")
          sct_attributes.delete("calendar_id")
          t.calendars_tls.build(sct_attributes)
        end
        t.save
        sc.calendar_items.each do |ci|
          ci_attributes = ci.attributes
          ci_attributes.delete("id")
          new_ci = Slm::CalendarItem.new(ci_attributes)
          new_ci.calendar_id = t.id
          new_ci.save
        end
      end
      puts("+++++++++finish Calendar")
      #copy agreements、trigger、trigger actions
      source_agreements.each do |sa|
        sa_attributes = sa.attributes
        sa_attributes.delete("id")
        t = Slm::ServiceAgreement.new(sa_attributes.merge({:not_auto_mult=>true}))
        t.external_system_id = source_project.id
        sa.service_agreements_tls.each do |sat|
          sat_attributes = sat.attributes
          sat_attributes.delete("id")
          sat_attributes.delete("service_agreement_id")
          t.service_agreements_tls.build(sat_attributes)
        end
        t.save
        sa.time_triggers.each do |tt|
          tt_attributes = tt.attributes
          tt_attributes.delete("id")
          new_tt = Slm::TimeTrigger.new(tt_attributes)
          new_tt.service_agreement_id = t.id
          new_tt.save
          tt.time_trigger_actions.each do |tta|
            tta_attributes = tta.attributes
            tta_attributes.delete("id")
            new_tta = Slm::TimeTriggerAction.new(tta_attributes)
            new_tta.time_trigger_id = new_tt.id
            new_tta.save
          end
        end
      end
      puts("+++++++++finish ServiceAgreement")
    end

  end

  def down
  end
end
