# -*- coding: utf-8 -*-
class FangzhengxinchanFromMantis < ActiveRecord::Migration
  def up

    #update person identity id for mantis
    users_result = execute(%Q(SELECT mut.id '0', mut.username '1', mut.realname '2', mut.email '3' FROM mantis_user_table mut))
    users_result.each do |ur|
      begin
      p = Irm::Person.where("email_address = ?", ur[3]).first
      p.update_attribute(:identity_id, ur[0])
      rescue
        next
      end
    end


    execute("CREATE TABLE tmp_icm_incident_requests LIKE icm_incident_requests") unless table_exists?(:tmp_icm_incident_requests)
    execute("DELETE FROM tmp_icm_incident_requests")

    execute("CREATE TABLE tmp_icm_incident_categories LIKE icm_incident_categories") unless table_exists?(:tmp_icm_incident_categories)
    execute("DELETE FROM tmp_icm_incident_categories")
    execute("CREATE TABLE tmp_icm_incident_categories_tl LIKE icm_incident_categories_tl") unless table_exists?(:tmp_icm_incident_categories_tl)
    execute("DELETE FROM tmp_icm_incident_categories_tl")
    execute("CREATE TABLE tmp_icm_incident_category_systems LIKE icm_incident_category_systems") unless table_exists?(:tmp_icm_incident_category_systems)
    execute("DELETE FROM tmp_icm_incident_category_systems")

    execute("CREATE TABLE tmp_icm_incident_journals LIKE icm_incident_journals") unless table_exists?(:tmp_icm_incident_journals)
    execute("DELETE FROM tmp_icm_incident_journals")
    execute("CREATE TABLE tmp_icm_incident_journal_elapses LIKE icm_incident_journal_elapses") unless table_exists?(:tmp_icm_incident_journal_elapses)
    execute("DELETE FROM tmp_icm_incident_journal_elapses")
    execute("CREATE TABLE tmp_icm_incident_histories LIKE icm_incident_histories") unless table_exists?(:tmp_icm_incident_histories)
    execute("DELETE FROM tmp_icm_incident_histories")
    execute("CREATE TABLE tmp_icm_incident_request_relations LIKE icm_incident_request_relations") unless table_exists?(:tmp_icm_incident_request_relations)
    execute("DELETE FROM tmp_icm_incident_request_relations")
    execute("CREATE TABLE tmp_irm_watchers LIKE irm_watchers") unless table_exists?(:tmp_irm_watchers)
    execute("DELETE FROM tmp_irm_watchers")
    #attachment
    execute("CREATE TABLE tmp_irm_attachment_versions LIKE irm_attachment_versions") unless table_exists?(:tmp_irm_attachment_versions)
    execute("DELETE FROM tmp_irm_attachment_versions")
    execute("CREATE TABLE tmp_irm_attachments LIKE irm_attachments") unless table_exists?(:tmp_irm_attachments)
    execute("DELETE FROM tmp_irm_attachments")

    #external system
    execute("CREATE TABLE tmp_irm_external_systems LIKE irm_external_systems") unless table_exists?(:tmp_irm_external_systems)
    execute("DELETE FROM tmp_irm_external_systems")
    execute("CREATE TABLE tmp_irm_external_systems_tl LIKE irm_external_systems_tl") unless table_exists?(:tmp_irm_external_systems_tl)
    execute("DELETE FROM tmp_irm_external_systems_tl")

    #group
    execute("CREATE TABLE tmp_irm_groups LIKE irm_groups") unless table_exists?(:tmp_irm_groups)
    execute("DELETE FROM tmp_irm_groups")
    execute("CREATE TABLE tmp_irm_groups_tl LIKE irm_groups_tl") unless table_exists?(:tmp_irm_groups_tl)
    execute("DELETE FROM tmp_irm_groups_tl")
    execute("CREATE TABLE tmp_icm_support_groups LIKE icm_support_groups") unless table_exists?(:tmp_icm_support_groups)
    execute("DELETE FROM tmp_icm_support_groups")
    #Step 3: Query from mantis
    opu = Irm::OperationUnit.where("short_name = ?", "Hand").first.id
    org = Irm::Organization.where("short_name = ?", "HAND_EBS_SUPPORT").first.id
    project_ids = ['1']

    org_result = execute(%Q(SELECT '' '0', '' '1', '' '2', mp.id '3', IF(mp.enabled, 'ENABLED', 'OFFLINE') '4',
                            -1 '5', -1 '6', now() '7', now() '8', '' '9', mp.name '10'
                            FROM mantis_project_table mp WHERE mp.id IN (#{project_ids.join(',')})))  #0531
    #hotline的每个项目，对应ironmine一个组、一个组织以及一个应用系统
    bo = Irm::BusinessObject.where(:bo_model_name => 'Icm::IncidentRequest').first

    code = Irm::Sequence.nextval("Irm::Organization", opu)
    #项目只迁移指定项目
    org_result.each do |r|
      ext_id = Fwk::IdGenerator.instance.generate("irm_external_systems")
      group_id = Fwk::IdGenerator.instance.generate("irm_groups")

      #external system
      execute(%Q(INSERT INTO tmp_irm_external_systems (id, opu_id, external_system_code, external_hostname, external_ip_address, status_code, created_by, updated_by, created_at, updated_at)
                  VALUES ('#{ext_id}', '#{opu}', '#{code}', '', '', '#{r[4]}', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}')))
      execute(%Q(INSERT INTO tmp_irm_external_systems_tl (id, opu_id, external_system_id, system_name, system_description, language, source_lang, status_code, created_by, updated_by, created_at, updated_at)
                  VALUES ('#{Fwk::IdGenerator.instance.generate("irm_external_systems_tl")}', '#{opu}', '#{ext_id}', '#{r[10]}', '#{r[10]}',
                          'zh', 'zh', '#{r[4]}', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}')))
      execute(%Q(INSERT INTO tmp_irm_external_systems_tl (id, opu_id, external_system_id, system_name, system_description, language, source_lang, status_code, created_by, updated_by, created_at, updated_at)
                  VALUES ('#{Fwk::IdGenerator.instance.generate("irm_external_systems_tl")}', '#{opu}', '#{ext_id}', '#{r[10]}', '#{r[10]}',
                          'en', 'zh', '#{r[4]}', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}')))

      #group
      execute(%Q(INSERT INTO tmp_irm_groups (id, opu_id, code, status_code, created_by, updated_by, created_at, updated_at)
                  VALUES ('#{group_id}', '#{opu}', '#{code}', '#{r[4]}', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}')))
      execute(%Q(INSERT INTO tmp_irm_groups_tl (id, opu_id, group_id, name, description, language, source_lang, status_code, created_by, updated_by, created_at, updated_at)
                  VALUES ('#{Fwk::IdGenerator.instance.generate("irm_groups_tl")}', '#{opu}', '#{group_id}', '#{r[10]}', '#{r[10]}',
                          'zh', 'zh', '#{r[4]}', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}')))
      execute(%Q(INSERT INTO tmp_irm_groups_tl (id, opu_id, group_id, name, description, language, source_lang, status_code, created_by, updated_by, created_at, updated_at)
                  VALUES ('#{Fwk::IdGenerator.instance.generate("irm_groups_tl")}', '#{opu}', '#{group_id}', '#{r[10]}', '#{r[10]}',
                          'en', 'zh', '#{r[4]}', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}')))

      execute(%Q(INSERT INTO tmp_icm_support_groups (id, opu_id, group_id, assignment_process_code, vendor_flag, oncall_flag, status_code, created_by, updated_by, created_at, updated_at)
                  VALUES ('#{Fwk::IdGenerator.instance.generate("icm_support_groups")}', '#{opu}', '#{group_id}', 'NEVER_ASSIGN', 'N',
                          'Y', '#{r[4]}', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}')))
    end

    #incident category

    close_reason = Icm::CloseReason.multilingual.where("close_code = ?", "NORMAL_CLOSE").first
    ir_category_result = execute(%Q(SELECT mc.id "0", mc.project_id "1", mc.name "2", -1 '3', -1 '4', now() '5', now() '6'
                                    FROM mantis_category_table mc WHERE LENGTH(mc.name) > 0 AND mc.project_id IN (#{project_ids.join(',')})))

    ir_category_result.each do |c|
      category_id = Fwk::IdGenerator.instance.generate("icm_incident_categories")
      cn_id = Fwk::IdGenerator.instance.generate("icm_incident_categories_tl")
      en_id = Fwk::IdGenerator.instance.generate("icm_incident_categories_tl")
      cs_id = Fwk::IdGenerator.instance.generate("icm_incident_category_systems")
      es = execute(%Q(SELECT id FROM tmp_irm_external_systems es WHERE es.external_system_code = '#{code}'))
      execute(%Q(INSERT INTO tmp_icm_incident_categories (id, opu_id, code, status_code, created_by, updated_by, created_at, updated_at)
              VALUES ('#{category_id}', '#{opu}', '#{c[0]}', 'ENABLED', '#{c[3]}', '#{c[4]}', '#{c[5]}', '#{c[6]}')))
      execute(%Q(INSERT INTO tmp_icm_incident_categories_tl (id, opu_id, incident_category_id, language, source_lang, name, description,
                status_code, created_by, updated_by, created_at, updated_at)
                      VALUES ('#{cn_id}', '#{opu}', '#{category_id}', 'zh', 'zh', "#{c[2]}", "#{c[2]}",
                      'ENABLED', '#{c[3]}', '#{c[4]}', '#{c[5]}', '#{c[6]}')))
            execute(%Q(INSERT INTO tmp_icm_incident_categories_tl (id, opu_id, incident_category_id, language, source_lang, name, description,
                      status_code, created_by, updated_by, created_at, updated_at)
                      VALUES ('#{en_id}', '#{opu}', '#{category_id}', 'en', 'zh', "#{c[2]}", "#{c[2]}",
                      'ENABLED', '#{c[3]}', '#{c[4]}', '#{c[5]}', '#{c[6]}')))
            #category system relation
      execute(%Q(INSERT INTO tmp_icm_incident_category_systems (id, opu_id, incident_category_id, external_system_id,
                status_code, created_by, updated_by, created_at, updated_at)
                VALUES ('#{cs_id}', '#{opu}', '#{category_id}', '#{es.first[0]}', 'ENABLED', '#{c[3]}', '#{c[4]}', '#{c[5]}', '#{c[6]}'))) if es.size > 0
    end


    #incident request
    ir_result = execute(%Q(SELECT mb.id '0', mb.project_id '1', mb.reporter_id '2', mb.handler_id '3', ipc.weight_values '4', iis.id '5', mb.bug_text_id '6',
                            mb.summary '7', tic.id '8', date_add('1970-01-01 08:00:00', interval mb.date_submitted second) '9',
                            date_add('1970-01-01 08:00:00', interval mb.last_updated second) '10', mbt.description '11',
                            mbt.additional_information '12', '' '13', '' '14', p_sub.id '15',
                            p_sup.id '16', es.id '17', '' '18', tic.id '19', -1 '20', -1 '21', now() '22', now() '23',
                            ipc.id '24', iir.id '25', iuc.id '26', mb.status '27', mbt.additional_information '28'
                            FROM mantis_bug_table mb
                            LEFT OUTER JOIN (tmp_icm_incident_categories tic) ON (tic.code = mb.category_id)
                            LEFT OUTER JOIN (irm_people p_sub) ON (p_sub.identity_id = mb.`reporter_id`)
                            LEFT OUTER JOIN (irm_people p_sup) ON (p_sup.identity_id = mb.`handler_id`)
                            LEFT OUTER JOIN (tmp_irm_external_systems es) ON (es.external_system_code = mb.project_id)
                            LEFT OUTER JOIN (icm_incident_statuses iis) ON (iis.incident_status_code = CASE mb.status
                            WHEN '10' THEN 'NEW'
                            WHEN '20' THEN 'PENDING'
                            WHEN '30' THEN 'PENDING'
                            WHEN '40' THEN 'PENDING'
                            WHEN '50' THEN 'ASSIGE'
                            WHEN '80' THEN 'DONE'
                            WHEN '90' THEN 'CLOSE'
                            ELSE '-1' END)
                            LEFT OUTER JOIN (icm_priority_codes ipc, icm_impact_ranges iir, icm_urgence_codes iuc)
                            ON (ipc.weight_values = CASE mb.priority
                            WHEN '10' THEN '5'
                            WHEN '20' THEN '4'
                            WHEN '30' THEN '3'
                            WHEN '40' THEN '2'
                            WHEN '50' THEN '1'
                            WHEN '60' THEN '1'
                            ELSE '5' END
                            AND iir.impact_code =  CASE ipc.`weight_values`
                            WHEN '5' THEN 'LOW'
                            WHEN '4' THEN 'NORMAL'
                            WHEN '3' THEN 'HIGH'
                            WHEN '2' THEN 'HIGH'
                            WHEN '1' THEN 'HIGH'
                            ELSE 'LOW' END
                            AND iuc.urgency_code = CASE ipc.`weight_values`
                            WHEN '5' THEN 'LOW'
                            WHEN '4' THEN 'LOW'
                            WHEN '3' THEN 'LOW'
                            WHEN '2' THEN 'MEDIUM'
                            WHEN '1' THEN 'HIGH'
                            ELSE 'LOW' END)
                            , mantis_bug_text_table mbt
                            WHERE mb.bug_text_id = mbt.id AND mb.project_id IN (#{project_ids.join(',')})
                            ))

    ir_result.each do |r|
      ir_id = Fwk::IdGenerator.instance.generate("icm_incident_requests")
      pt = r[14]

      title = r[7]
      title = r[7].gsub("'", /\\'/.source)
      content = r[11]
      content = r[11].gsub("'", /\\'/.source)
      content = "<pre>" + content + "</pre>"
      close_reason_id = ''
      if r[27] == "90"
        close_reason_id = close_reason.id
      end
      #0510
      support_group = "-1"
      support_group = execute(%Q(select sg.id from tmp_icm_support_groups sg, tmp_irm_groups g WHERE sg.group_id = g.id AND g.code = '#{r[1]}'))
      if support_group.size == 0 or r[16].blank?
        support_group = ""
      else
        support_group = support_group.first[0]
      end
      contact_number = ""
      contact_number = r[28].gsub("\\", /\\\\/.source).gsub("'", /\\'/.source)
      execute(%Q(INSERT INTO tmp_icm_incident_requests (request_type_code, report_source_code, id, request_number, title, summary, hotline,
                  external_system_id, incident_category_id, requested_by, organization_id, submitted_by, weight_value, contact_id, contact_number,
                  incident_status_id, priority_id, impact_range_id, urgence_id, close_reason_id, real_processing_time, support_group_id, support_person_id,
                  submitted_date,reply_count, last_request_date, last_response_date, opu_id, status_code, created_by, updated_by, created_at, updated_at)
                VALUES ('REQUESTED_TO_PERFORM', 'CUSTOMER_SUBMIT', '#{ir_id}','#{r[0]}', '#{title}','#{content}','N',
                        '#{r[17]}','#{r[8]}','#{r[15]}','#{org}','#{r[15]}','#{r[4]}','#{r[15]}','#{contact_number}',
                        '#{r[5]}','#{r[24]}','#{r[25]}','#{r[26]}','#{close_reason_id}','#{pt}', '#{support_group}', '#{r[16]}',
                        '#{r[9]}','1','#{r[10]}', '#{r[10]}', '#{opu}', 'ENABLED', '#{r[20]}','#{r[21]}','#{r[9]}','#{r[10]}')
                ))
      #watchers
      #将提交人和处理人添加为watcher
      execute(%Q(INSERT INTO tmp_irm_watchers (id, opu_id, watchable_id, watchable_type, member_id,
                        member_type, deletable_flag, created_by, updated_by, created_at, updated_at)
                VALUES ('#{Fwk::IdGenerator.instance.generate("irm_watchers")}', '#{opu}', '#{ir_id}', 'Icm::IncidentRequest', '#{r[15]}', 'Irm::Person',
                        'N', '#{r[15]}', '#{r[15]}', '#{r[22]}', '#{r[22]}')
                )) if r[15].present?
      execute(%Q(INSERT INTO tmp_irm_watchers (id, opu_id, watchable_id, watchable_type, member_id,
                        member_type, deletable_flag, created_by, updated_by, created_at, updated_at)
                VALUES ('#{Fwk::IdGenerator.instance.generate("irm_watchers")}', '#{opu}', '#{ir_id}', 'Icm::IncidentRequest', '#{r[16]}', 'Irm::Person',
                        'N', '#{r[15]}', '#{r[15]}', '#{r[22]}', '#{r[22]}')
                )) if r[16].present? if r[15] != r[16]

      #create close journal, journal elapse, journal history, journal

      #journal
      journal = execute(%Q(SELECT mbn.bug_id '0', ip.id '1', mbnt.note '2', date_add('1970-01-01 08:00:00', interval mbn.last_modified second) '3',
                            date_add('1970-01-01 08:00:00', interval mbn.date_submitted second) '4',
                            (SELECT MAX(date_add('1970-01-01 08:00:00', interval last_mbn.last_modified second))
                            FROM mantis_bugnote_table last_mbn WHERE last_mbn.bug_id = mbn.bug_id  AND last_mbn.last_modified < mbn.last_modified) '5', mbnt.id '6'
                            FROM mantis_bugnote_table mbn, mantis_bugnote_text_table mbnt, irm_people ip
                            WHERE mbn.bugnote_text_id = mbnt.id AND ip.identity_id = mbn.reporter_id AND mbn.bug_id = '#{r[0]}'
                      ))
      journal.each do |j|
        note = j[2]
        note = j[2].gsub("\\", /\\\\/.source).gsub("'", /\\'/.source)
        note = "<pre>" + note + "</pre>"
        j_id = Fwk::IdGenerator.instance.generate("icm_incident_journals")
        #journal
        execute(%Q(INSERT INTO tmp_icm_incident_journals (id, journal_number, opu_id, incident_request_id, reply_type, replied_by, message_body,
                              status_code, created_by, updated_by, created_at, updated_at)
                    VALUES ('#{j_id}', '#{j[6]}', '#{opu}', '#{ir_id}', 'OTHER_REPLY',
                              '#{j[1]}', '#{note}', 'ENABLED', '#{j[1]}', '#{j[1]}', '#{j[3]}', '#{j[3]}')
                    ))

        #history
        execute(%Q(INSERT INTO tmp_icm_incident_histories (id, opu_id, request_id, journal_id, property_key, old_value, new_value,
                              status_code, created_by, updated_by, created_at, updated_at)
                       VALUES ('#{Fwk::IdGenerator.instance.generate("icm_incident_histories")}', '#{opu}', '#{ir_id}',
                              '#{j_id}', 'new_reply', '', '#{j[6]}',
                              'ENABLED', '#{j[1]}', '#{j[1]}', '#{j[3]}', '#{j[3]}')))

        #journal elapse
        last_at = j[4] #last note date
        if last_at.nil? #if no pre. exists
          last_at = r[9] #mantis bug submit date
        end
        execute(%Q(INSERT INTO tmp_icm_incident_journal_elapses (id, opu_id, incident_journal_id, elapse_type,
                              support_group_id, incident_status_id, start_at, end_at, distance, real_distance,
                              status_code, created_by, updated_by, created_at, updated_at)
                              VALUES ('#{Fwk::IdGenerator.instance.generate("icm_incident_journal_elapses")}', '#{opu}', '#{j_id}', 'OTHER_REPLY',
                              '','','#{last_at}', '#{j[4]}', '#{DateTime.parse(j[4]) - DateTime.parse(last_at)}', '#{DateTime.parse(j[4]) - DateTime.parse(last_at)}',
                              'ENABLED', '#{j[1]}', '#{j[1]}', '#{j[3]}', '#{j[3]}')
                              ))
        #将进行过回复的人员都添加进watcher
        ex = execute(%Q(SELECT iw.id FROM tmp_irm_watchers iw WHERE iw.watchable_id = '#{ir_id}' AND iw.member_id = '#{j[1]}'))
        execute(%Q(INSERT INTO tmp_irm_watchers (id, opu_id, watchable_id, watchable_type, member_id,
                          member_type, deletable_flag, created_by, updated_by, created_at, updated_at)
                  VALUES ('#{Fwk::IdGenerator.instance.generate("irm_watchers")}', '#{opu}', '#{ir_id}', 'Icm::IncidentRequest', '#{j[1]}', 'Irm::Person',
                          'Y', '#{j[1]}', '#{j[1]}', '#{j[3]}', '#{j[3]}')
                  )) unless ex.any?
      end

      #journal history
      his = execute(%Q(SELECT mbh.bug_id '0', ip.id '1', mbh.old_value '2', mbh.new_value '3', mbh.type '4',
                                    date_add('1970-01-01 08:00:00', interval mbh.date_modified second) '5', mbh.field_name '6'
                                    FROM mantis_bug_history_table mbh, irm_people ip
                                    WHERE mbh.type IN ('0','1','2','9','10','12','18','19')
                                    AND ip.identity_id = mbh.user_id AND field_name NOT IN  ("解决问题花费时间", "解决问题花费时间/H", "BUG NUMBER")
                                    AND mbh.bug_id = '#{r[0]}'
                              ))
      his.each do |h|
        j_id = Fwk::IdGenerator.instance.generate("icm_incident_journals")
        if ['0', '1', '2', '9', '12', '18', '19'].include?(h[4].to_s)
          jump_journal = false
          action_type = 'ATTRIBUTE_CHANGED'
          field_name = ''
          old_value = ''
          old_value = h[2].gsub("\\", /\\\\/.source).gsub("'", /\\'/.source) unless h[2].nil?
          new_value = ''
          new_value = h[3].gsub("\\", /\\\\/.source).gsub("'", /\\'/.source) unless h[3].nil?
          case h[6]
            #when "BUG NUMBER"
            #  field_name = "request_number"
            when "category"
              field_name = "incident_category_id"
              begin
                old_value = execute(%Q(SELECT iic.id FROM tmp_icm_incident_categories iic,
                                      mantis_category_table mc WHERE iic.code = mc.id AND mc.name = '#{old_value}'
                                      AND mc.project_id = '#{r[1]}')).first[0] if old_value.present?
              rescue
              end
              begin
                new_value = execute(%Q(SELECT iic.id FROM tmp_icm_incident_categories iic,
                                      mantis_category_table mc WHERE iic.code = mc.id AND mc.name = '#{new_value}'
                                      AND mc.project_id = '#{r[1]}')).first[0] if new_value.present?
              rescue
              end

            when "handler_id"
              field_name = "support_person_id"
              begin
                old_value = execute(%Q(SELECT ip.id FROM irm_people ip WHERE ip.identity_id = '#{old_value}')).first[0] if old_value.present?
              rescue
              end
              begin
                new_value = execute(%Q(SELECT ip.id FROM irm_people ip WHERE ip.identity_id = '#{new_value}')).first[0] if new_value.present?
              rescue
              end
              action_type = 'ASSIGN' if (old_value.blank? ||old_value == 0) && !new_value.blank?
              action_type = 'PASS' if !old_value.blank? && !new_value.blank?
            when "os" || "os_build" || "platform"
              field_name = "client_info"
            when "priority"
              field_name = "priority_id"
              case old_value
                when '10'
                  old_value = '5'
                when '20'
                  old_value = '4'
                when '30'
                  old_value = '3'
                when '40'
                  old_value = '2'
                when '50'
                  old_value = '1'
                when '60'
                  old_value = '1'
              end if old_value.present?
              case new_value
                when '10'
                  new_value = '5'
                when '20'
                  new_value = '4'
                when '30'
                  new_value = '3'
                when '40'
                  new_value = '2'
                when '50'
                  new_value = '1'
                when '60'
                  new_value = '1'
              end if new_value.present?
            when "project_id"
              field_name = "external_system_id"
              o = old_value
              n = new_value
              begin
                old_value = execute(%Q(SELECT ie.id FROM tmp_irm_external_systems ie WHERE ie.external_system_code = '#{old_value}')).first[0] if old_value.present?
                old_org = ''
                old_org = execute(%Q(SELECT io.id FROM tmp_irm_organizations io WHERE io.short_name = '#{o}')).first[0] if old_value.present?
              rescue
              end
              begin
                new_value = execute(%Q(SELECT ie.id FROM tmp_irm_external_systems ie WHERE ie.external_system_code = '#{new_value}')).first[0] if new_value.present?
                new_org = ''
                new_org = execute(%Q(SELECT io.id FROM tmp_irm_organizations io WHERE io.short_name = '#{n}')).first[0] if new_value.present?
              rescue
              end
              execute(%Q(INSERT INTO tmp_icm_incident_histories (id, opu_id, request_id, journal_id, property_key, old_value, new_value,
                                    status_code, created_by, updated_by, created_at, updated_at)
                             VALUES ('#{Fwk::IdGenerator.instance.generate("icm_incident_histories")}', '#{opu}', '#{ir_id}',
                                    '#{j_id}', 'organization_id', '#{old_org}', '#{new_org}',
                                    'ENABLED', '#{h[1]}', '#{h[1]}', '#{h[5]}', '#{h[5]}'))) if field_name.present? && (old_value.present? || new_value.present?)
            when "reporter_id"
              field_name = "requested_by"
              begin
                old_value = execute(%Q(SELECT ip.id FROM irm_people ip WHERE ip.identity_id = '#{old_value}')).first[0] if old_value.present?
              rescue
              end
              begin
                new_value = execute(%Q(SELECT ip.id FROM irm_people ip WHERE ip.identity_id = '#{new_value}')).first[0] if new_value.present?
              rescue
              end
            when "status"
              field_name = "incident_status_id"
              case old_value.to_s
                when '10'
                  old_value = 'NEW'
                when '20'
                  old_value = 'PENDING'
                when '30'
                  old_value = 'PENDING'
                when '40'
                  old_value = 'PENDING'
                when '50'
                  old_value = 'ASSIGE'
                when '80'
                  old_value = 'DONE'
                when '90'
                  old_value = 'CLOSE'
              end if old_value.present?
              old_value = execute(%Q(SELECT iis.id FROM icm_incident_statuses iis WHERE iis.incident_status_code = '#{old_value}')).first[0] if old_value.present?
              case new_value.to_s
                when '10'
                  new_value = 'NEW'
                when '20'
                  new_value = 'PENDING'
                when '30'
                  new_value = 'PENDING'
                when '40'
                  new_value = 'PENDING'
                when '50'
                  new_value = 'ASSIGE'
                when '80'
                  new_value = 'DONE'
                when '90'
                  new_value = 'CLOSE'
              end if new_value.present?
              new_value = execute(%Q(SELECT iis.id FROM icm_incident_statuses iis WHERE iis.incident_status_code = '#{new_value}')).first[0] if new_value.present?
              action_type = 'CLOSE' if new_value.eql?('CLOSE')
            when "summary"
              field_name = "title"
            #when "解决问题花费时间" || "解决问题花费时间/H"
            #  field_name = "real_processing_time"
            else
              case h[4].to_s
                when "1" #新建问题
                  field_name = "incident_request_id"
                  jump_journal = true
                  old_value = r[7].gsub("\\", /\\\\/.source).gsub("'", /\\'/.source) #标题
                #when "2" #新增注释(回复)
                #  field_name = "new_reply"
                #  old_value = ""
                #  new_value = ""
                when "9" #添加附件
                  field_name = "attachment"
                  jump_journal = true
                when "10" #移除附件
                  field_name = "remove_attachment"
                  jump_journal = true
                when "12" #添加监视人
                  field_name = "watcher"
                  jump_journal = true
                  begin
                    old_value = execute(%Q(SELECT ip.id FROM irm_people ip WHERE ip.identity_id = '#{old_value}')).first[0] if old_value.present?
                  rescue
                  end
                when "18" #添加关联
                  field_name = "add_relation"
                  jump_journal = true
                  case h[2].to_s
                    when '0' || '4'
                      old_value = 'SAME'
                    when '1'
                      old_value = 'RELATION'
                    when '2'
                      old_value = 'CHILD'
                    when '3'
                      old_value = 'PARENT'
                    else
                      old_value = 'RELATION'
                  end
                  #暂时设置等于mantis newvalue，等request数据全部导入后再进行修正
                  new_value = new_value
                when "19" #删除关联
                  field_name = "remove_relation"
                  jump_journal = true
                  case h[2].to_s
                    when '0' || '4'
                      old_value = 'SAME'
                    when '1'
                      old_value = 'RELATION'
                    when '2'
                      old_value = 'CHILD'
                    when '3'
                      old_value = 'PARENT'
                    else
                      old_value = 'RELATION'
                  end
                  #暂时设置等于mantis newvalue，等request数据全部导入后再进行修正
                  new_value = new_value
                else
                  next
              end
          end
          execute(%Q(INSERT INTO tmp_icm_incident_journals (id, opu_id, incident_request_id, reply_type, replied_by, message_body,
                                status_code, created_by, updated_by, created_at, updated_at)
                      VALUES ('#{j_id}', '#{opu}', '#{ir_id}', '#{action_type}',
                                '#{h[1]}', '#{field_name}', 'ENABLED', '#{h[1]}', '#{h[1]}', '#{h[5]}', '#{h[5]}')
                      )) if field_name.present? && (old_value.present? || new_value.present?) && !jump_journal
          j_id = "" if jump_journal
          execute(%Q(INSERT INTO tmp_icm_incident_histories (id, opu_id, request_id, journal_id, property_key, old_value, new_value,
                                status_code, created_by, updated_by, created_at, updated_at)
                         VALUES ('#{Fwk::IdGenerator.instance.generate("icm_incident_histories")}', '#{opu}', '#{ir_id}',
                                '#{j_id}', '#{field_name}', '#{old_value}', '#{new_value}',
                                'ENABLED', '#{h[1]}', '#{h[1]}', '#{h[5]}', '#{h[5]}'))) if field_name.present? && (old_value.present? || new_value.present?)
        end
      end
    end
  end

  def down
  end
end
