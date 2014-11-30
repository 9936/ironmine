class CopySlaData < ActiveRecord::Migration
  def up
    #source project
    source_project = Irm::ExternalSystem.where("external_system_code = ?", 10538)
    if source_project.any?
      source_project = source_project.first
    else
      puts("+++++++++running false")
      return false
    end

    hotline_projects = Irm::ExternalSystem.where("id IN '000q000402oPdrTG9mq7o8',
                                                  '000q000404JI4XmwYTMu4O',
                                                  '000q00040NVgggHK9PnBJo',
                                                  '000q00040OIbknQSk5dL4C',
                                                  '000q00040OKNeCqN2hEolM',
                                                  '000q00040ldeyhJAU9f5km',
                                                  '000q00040pPyvUoMCoviZk',
                                                  '000q00040tvKAuK2mx7wqe',
                                                  '000q00041Dl4QkHEm0lKuu',
                                                  '000q00041E4DHZaovh0WuG',
                                                  '000q00041LrkHoSrU8jfGK',
                                                  '000q00041Pf8Aena9e6Zo8',
                                                  '000q00041TxMCpphjUsOEi',
                                                  '000q00041mdUkuRNy1Ie12',
                                                  '000q00041zhACaFlbCbFaa',
                                                  '000q00042DYSfjokZVWO6i',
                                                  '000q00042Lq7rwp5Nvwmhs',
                                                  '000q00042RdEKo9lgfJNei',
                                                  '000q00042Z3Mk2MazmdjlY',
                                                  '000q00042bhUtni31tkJaS',
                                                  '000q00042ipuMvl5JEjc3M',
                                                  '000q00042kSaKcKGOgjZj6',
                                                  '000q00042kglTtfjegBmuO',
                                                  '000q00042n26lVyvcaPv3g',
                                                  '000q00042rYrvefqDMwPvE',
                                                  '000q00073mX46ylYvyWhs0',
                                                  '000q00073mX46ylYvyl12e',
                                                  '000q00073mX46ylYvymYRk',
                                                  '000q00073mX46ylYvyo0q8',
                                                  '000q00073mX46ylYvypXe4',
                                                  '000q00073mX46ylYvyrJZ2',
                                                  '000q00073mX46ylYvyt1Dk',
                                                  '000q00073mX46ylYvyumqO',
                                                  '000q00073mX46ylYvywMMq',
                                                  '000q00073mX46ylYvyyAN6',
                                                  '000q00073mX46ylYvz4PdQ',
                                                  '000q00073mabtnlQT8fuym',
                                                  '000q00073mabtnlQTId3WC',
                                                  '000q00073mabtnlQTKrVPU',
                                                  '000q00073mabtnlQTTo8mm',
                                                  '000q00073mabtnlQTVzES8',
                                                  '000q00073mabtnlQTdKSUC',
                                                  '000q00073mabtnlQTvOaDA',
                                                  '000q00073mabtnlQTzDemu',
                                                  '000q00073mabtnlQU5RFFw',
                                                  '000q00073mabtnlQUAdVrM',
                                                  '000q00073mabtnlQUDQeTw',
                                                  '000q00073mabtnlQUGq6c4',
                                                  '000q00073mabtnlQUJ1BgG',
                                                  '000q00073mabtnlQUK6Kv2',
                                                  '000q00073mabtnlQUNDJdg',
                                                  '000q00073mabtnlQUO1oae',
                                                  '000q00073mabtnlQUOBt56',
                                                  '000q00073mabtnlQUOqz3o',
                                                  '000q00073mabtnlQUPZMTA',
                                                  '000q00073mabtnlQUoexv6',
                                                  '000q00073mabtnlQV0v9u4',
                                                  '000q00073mabtnlQV4GqLA',
                                                  '000q00073mabtnlQV4tQMS',
                                                  '000q00073mabtnlQVDVw24',
                                                  '000q00073mabtnlQVE4jjM',
                                                  '000q00073mabtnlQVEciX2',
                                                  '000q00073mabtnlQVKnlYG',
                                                  '000q00073mabtnlQVLssXg',
                                                  '000q00073mabtnlQVMzGq0',
                                                  '000q00073mabtnlQVOcnDs',
                                                  '000q00073mabtnlQVQGKi8',
                                                  '000q00075fJztN5Sm2w1wm',
                                                  '000q00075jMyqDtScPNnNY',
                                                  '000q00075qSuSZuKFqlZaa',
                                                  '000q00075yqbINm0DFyH7w'").where("id <> ?", source_project.id)

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

          puts("+++++++++ sa:" + sa.to_json)
          puts("+++++++++ sa_attributes:" + sa_attributes.to_json)
          ts = Slm::ServiceAgreement.new(sa_attributes.merge({:not_auto_mult=>true}))
          ts.external_system_id = hp.id
          ts.calendar_id = t.id
          sa.service_agreements_tls.each do |sat|
            sat_attributes = sat.attributes
            sat_attributes.delete("id")
            sat_attributes.delete("created_at")
            sat_attributes.delete("updated_at")
            sat_attributes.delete("service_agreement_id")
            ts.service_agreements_tls.build(sat_attributes)
          end
          ts.duration_minute = sa.duration.to_i
          ts.save
          puts("+++++++++ ts:" + ts.to_json)
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
            rf.rule_filter_criterions.each do |rfc|
              rfc_attributes = rfc.attributes
              rfc_attributes.delete("id")
              rfc_attributes.delete("rule_filter_id")
              rfc_attributes.delete("created_at")
              rfc_attributes.delete("updated_at")
              new_rf.rule_filter_criterions.build(rfc_attributes)
            end
            puts("++++++++++++++++++ new rf: " + new_rf.to_json)
            new_rf.save
            if new_rf.errors.any?
              puts("+++++++++new rf errors" + new_rf.errors.to_json)
            end
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
