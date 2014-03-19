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
    source_agreements = Slm::ServiceAgreement.where("external_system_id = ?", source_project.id)
    puts("+++++++++start copy")
    #starting copy
    hotline_projects.each do |hp|
      #copy calendar、calendar items
      source_calendars.each do |sc|
        t_sc = sc.attributes
        t_sc.delete("id")
        t_sc.delete("created_at")
        t_sc.delete("updated_at")
        t = Slm::Calendar.new(t_sc.merge({:not_auto_mult=>true}))
        t.external_system_id = hp.id
        sc.calendars_tls.each do |sct|
          sct_attributes = sct.attributes
          sct_attributes.delete("id")
          sct_attributes.delete("calendar_id")
          sct_attributes.delete("created_at")
          sct_attributes.delete("updated_at")
          t.calendars_tls.build(sct_attributes)
        end
        t.save
        sc.calendar_items.each do |ci|
          ci_attributes = ci.attributes
          ci_attributes.delete("id")
          ci_attributes.delete("created_at")
          ci_attributes.delete("updated_at")
          new_ci = Slm::CalendarItem.new(ci_attributes)
          new_ci.calendar_id = t.id
          new_ci.save
        end

        #copy agreements、trigger、trigger actions
        source_agreements.where("calendar_id = ?", sc.id).each do |sa|
          sa_attributes = sa.attributes
          sa_attributes.delete("id")
          sa_attributes.delete("created_at")
          sa_attributes.delete("updated_at")
          ts = Slm::ServiceAgreement.new(sa_attributes.merge({:not_auto_mult=>true}))
          ts.external_system_id = hp.id
          ts.calendar_id = t.id
          ts.duration = sa.duration
          sa.service_agreements_tls.each do |sat|
            sat_attributes = sat.attributes
            sat_attributes.delete("id")
            sat_attributes.delete("created_at")
            sat_attributes.delete("updated_at")
            sat_attributes.delete("service_agreement_id")
            ts.service_agreements_tls.build(sat_attributes)
          end
          ts.save

          Irm::RuleFilter.where("source_id = ?", sa.id).each do |rf|
            rf_attributes = rf.attributes
            rf_attributes.delete("id")
            rf_attributes.delete("created_at")
            rf_attributes.delete("updated_at")
            new_rf = Irm::RuleFilter.new(rf_attributes.merge({:not_auto_mult => true}))
            new_rf.source_id = ts.id
            rf.rule_filters_tls.each do |rft|
              rft_attributes = rft.attributes
              rft_attributes.delete("id")
              rft_attributes.delete("rule_filter_id")
              rft_attributes.delete("created_at")
              rft_attributes.delete("updated_at")
              new_rf.rule_filters_tls.build(rft_attributes)
            end
            new_rf.save
          end

          sa.time_triggers.each do |tt|
            tt_attributes = tt.attributes
            tt_attributes.delete("id")
            tt_attributes.delete("created_at")
            tt_attributes.delete("updated_at")
            new_tt = Slm::TimeTrigger.new(tt_attributes)
            new_tt.service_agreement_id = ts.id
            new_tt.save
            tt.time_trigger_actions.each do |tta|
              tta_attributes = tta.attributes
              tta_attributes.delete("id")
              tta_attributes.delete("created_at")
              tta_attributes.delete("updated_at")
              new_tta = Slm::TimeTriggerAction.new(tta_attributes)
              new_tta.time_trigger_id = new_tt.id
              new_tta.save
            end
          end
        end
      end
    end

  end

  def down
  end
end
