# -*- coding:utf-8 -*-
class MoveMantisDataToTmpTables < ActiveRecord::Migration
  def up
    execute("DELETE FROM tmp_icm_incident_requests")
    execute("DELETE FROM tmp_icm_incident_workloads")

    execute("DELETE FROM tmp_icm_incident_categories")
    execute("DELETE FROM tmp_icm_incident_categories_tl")
    execute("DELETE FROM tmp_icm_incident_category_systems")

    execute("DELETE FROM tmp_icm_incident_journals")
    execute("DELETE FROM tmp_icm_incident_journal_elapses")
    execute("DELETE FROM tmp_icm_incident_histories")
    execute("DELETE FROM tmp_icm_incident_request_relations")
    execute("DELETE FROM tmp_irm_watchers")
    #attachment
    execute("DELETE FROM tmp_irm_attachment_versions")
    execute("DELETE FROM tmp_irm_attachments")

    #people
    execute("DELETE FROM tmp_irm_people")

    #organization
    execute("DELETE FROM tmp_irm_organizations")
    execute("DELETE FROM tmp_irm_organizations_tl")

    #external system
    execute("DELETE FROM tmp_irm_external_systems")
    execute("DELETE FROM tmp_irm_external_systems_tl")
    execute("DELETE FROM tmp_icm_external_system_groups")

    #group
    execute("DELETE FROM tmp_irm_groups")
    execute("DELETE FROM tmp_irm_groups_tl")
    execute("DELETE FROM tmp_irm_group_members")
    execute("DELETE FROM tmp_icm_support_groups")

    execute("DELETE FROM tmp_irm_object_attributes")
    execute("DELETE FROM tmp_irm_object_attributes_tl")
    execute("DELETE FROM tmp_irm_object_attribute_systems")

    opu = Irm::OperationUnit.where("short_name = ?", "Hand").first.id
    opu_id = Irm::OperationUnit.where("short_name = ?", "Hand").first.id

    org_result = execute(%Q(SELECT '' '0', '' '1', '' '2', mp.id '3', IF(mp.enabled, 'ENABLED', 'OFFLINE') '4',
                            -1 '5', -1 '6', now() '7', now() '8', '' '9', mp.name '10'
                            FROM mantis_project_table mp))  #0510

    #用户全部迁移
    user_result = execute(%Q(SELECT mu.id '0', mu.username '1', mu.realname '2', mu.email '3',
                            '02ebb6bb838bd2cf6eb168f1ea026454c0e9e5e1' '4', IF(mu.enabled, 'ENABLED', 'OFFLINE') '5', -1 '6', -1 '7', now() '8', now() '9'
                            FROM mantis_user_table mu))
    user_result.each do |u|
      user_id = Fwk::IdGenerator.instance.generate("irm_people")
      if u[3].end_with?("hand-china.com")
        profile_id = "001z00012i8IyyjJaqK4AK"
      else
        profile_id = "001z00024DLIQpNqWEiUOO"
      end

      execute(%Q(INSERT INTO tmp_irm_people (id, opu_id, organization_id, first_name, hashed_password, bussiness_phone, profile_id, last_name,
                  full_name, email_address, status_code, created_by, updated_by, created_at, updated_at, login_name, identity_id)
                  VALUES ('#{user_id}', '#{opu}', '001q000922rYQQ3HDRwrOy', '#{u[2]}', 'd1fe845de344506ec09e284bf3fc704c67e68862', '123456', '#{profile_id}', '',
                          '#{u[2]}', '#{u[3]}', '#{u[5]}', '#{u[6]}', '#{u[7]}', '#{u[8]}', '#{u[9]}', '#{u[1]}', '#{u[0]}')))
    end

    #项目只迁移指定项目
    org_result.each do |r|
      org_id = Fwk::IdGenerator.instance.generate("irm_organizations")
      ext_id = Fwk::IdGenerator.instance.generate("irm_external_systems")
      group_id = Fwk::IdGenerator.instance.generate("irm_groups")
      #organization
      execute(%Q(INSERT INTO tmp_irm_organizations (id, opu_id, parent_org_id, short_name, status_code, created_by, updated_by, created_at, updated_at, ldap_dn)
                  VALUES ('#{org_id}', '#{opu}', '', '#{r[3]}', '#{r[4]}', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}', '')))
      execute(%Q(INSERT INTO tmp_irm_organizations_tl (id, opu_id, organization_id, language, name, description, source_lang, status_code, created_by, updated_by, created_at, updated_at)
                  VALUES ('#{Fwk::IdGenerator.instance.generate("irm_organizations_tl")}', '#{opu}', '#{org_id}', 'zh', '#{r[10]}', '#{r[10]}', 'zh', '#{r[4]}', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}')))
      execute(%Q(INSERT INTO tmp_irm_organizations_tl (id, opu_id, organization_id, language, name, description, source_lang, status_code, created_by, updated_by, created_at, updated_at)
                  VALUES ('#{Fwk::IdGenerator.instance.generate("irm_organizations_tl")}', '#{opu}', '#{org_id}', 'en', '#{r[10]}', '#{r[10]}', 'zh', '#{r[4]}', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}')))

      #external system
      execute(%Q(INSERT INTO tmp_irm_external_systems (id, opu_id, external_system_code, external_hostname, external_ip_address, status_code, created_by, updated_by, created_at, updated_at)
                  VALUES ('#{ext_id}', '#{opu}', '#{r[3]}', '', '', '#{r[4]}', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}')))
      execute(%Q(INSERT INTO tmp_irm_external_systems_tl (id, opu_id, external_system_id, system_name, system_description, language, source_lang, status_code, created_by, updated_by, created_at, updated_at)
                  VALUES ('#{Fwk::IdGenerator.instance.generate("irm_external_systems_tl")}', '#{opu}', '#{ext_id}', '#{r[10]}', '#{r[10]}',
                          'zh', 'zh', '#{r[4]}', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}')))
      execute(%Q(INSERT INTO tmp_irm_external_systems_tl (id, opu_id, external_system_id, system_name, system_description, language, source_lang, status_code, created_by, updated_by, created_at, updated_at)
                  VALUES ('#{Fwk::IdGenerator.instance.generate("irm_external_systems_tl")}', '#{opu}', '#{ext_id}', '#{r[10]}', '#{r[10]}',
                          'en', 'zh', '#{r[4]}', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}')))

      #group
      execute(%Q(INSERT INTO tmp_irm_groups (id, opu_id, code, status_code, created_by, updated_by, created_at, updated_at)
                  VALUES ('#{group_id}', '#{opu}', '#{r[3]}', '#{r[4]}', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}')))
      execute(%Q(INSERT INTO tmp_irm_groups_tl (id, opu_id, group_id, name, description, language, source_lang, status_code, created_by, updated_by, created_at, updated_at)
                  VALUES ('#{Fwk::IdGenerator.instance.generate("irm_groups_tl")}', '#{opu}', '#{group_id}', '#{r[10]}', '#{r[10]}',
                          'zh', 'zh', '#{r[4]}', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}')))
      execute(%Q(INSERT INTO tmp_irm_groups_tl (id, opu_id, group_id, name, description, language, source_lang, status_code, created_by, updated_by, created_at, updated_at)
                  VALUES ('#{Fwk::IdGenerator.instance.generate("irm_groups_tl")}', '#{opu}', '#{group_id}', '#{r[10]}', '#{r[10]}',
                          'en', 'zh', '#{r[4]}', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}')))
      support_group_id = Fwk::IdGenerator.instance.generate("icm_support_groups")
      execute(%Q(INSERT INTO tmp_icm_support_groups (id, opu_id, group_id, assignment_process_code, vendor_flag, oncall_flag, status_code, created_by, updated_by, created_at, updated_at)
                  VALUES ('#{support_group_id}', '#{opu}', '#{group_id}', 'NEVER_ASSIGN', 'N',
                          'Y', '#{r[4]}', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}')))
      #set group system
      external_system_group_id = Fwk::IdGenerator.instance.generate("icm_external_system_groups")
      execute(%Q(INSERT INTO tmp_icm_external_system_groups (id, opu_id, external_system_id, support_group_id, status_code, created_by, updated_by, created_at, updated_at)
                                                                VALUES
                                                            ('#{external_system_group_id}', '#{opu}', '#{ext_id}', '#{support_group_id}', '#{r[4]}', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}')))
      user_result.each do |u|
        re = execute(%Q(SELECT mup.project_id '0', mup.user_id '1', ip.id '2', ip.email_address '3' FROM mantis_project_user_list_table mup, tmp_irm_people ip
                        WHERE mup.user_id = ip.identity_id AND mup.user_id = '#{u[0]}' AND mup.project_id = '#{r[3]}'))
        re.each do |t|
          #set person org
          execute(%Q(UPDATE tmp_irm_people SET organization_id = '#{org_id}' WHERE id = '#{u[0]}' AND email_address NOT LIKE '%hand-china.com'))
          #set person group
          person_group_id = Fwk::IdGenerator.instance.generate("irm_group_members")
          execute(%Q(INSERT INTO tmp_irm_group_members (id, opu_id, group_id, person_id, status_code, created_by, updated_by, created_at, updated_at) VALUES
                                                       ('#{person_group_id}', '#{opu}', '#{group_id}', '#{t[2]}', '#{r[4]}', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}')))
          external_system_people_id = Fwk::IdGenerator.instance.generate("irm_external_system_people")
          if u[3].end_with?("hand-china.com")
            system_profile_id = "001z00040CSnl4HOpHUGf2"
          else
            system_profile_id = "001z00040CSnl4HOodQjE8"
          end
          execute(%Q(INSERT INTO tmp_irm_external_system_people (id, opu_id, external_system_id, system_profile_id, person_id,
                                                                  status_code, created_by, updated_by, created_at, updated_at)
                                                                VALUES
                                                                ('#{external_system_people_id}', '#{opu}', '#{ext_id}', '#{system_profile_id}', '#{t[2]}',
                                                                  '#{r[4]}', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}')))
        end
      end


      #move custom field for each external_system
      cux_field_result = execute(%Q(SELECT mcf.id "0", mcf.name "1", mcf.type "2", -1 '3', -1 '4', now() '5', now() '6', mcf.possible_values '7', mcf.default_value '8', mcfp.sequence '9'
                                      FROM mantis_custom_field_table mcf, mantis_custom_field_project_table mcfp WHERE mcfp.field_id = mcf.id AND mcfp.project_id = '#{r[3]}'))

      attribute_count = 6
      cux_field_result.each do |cux|

        cux_category = ""
        data_type = "varchar"
        data_null_flag = "Y"
        data_length = "240"
        data_default_value = cux[8]
        pick_list_options = ""
        data_extra_info = cux[0]
        cux_field_id = Fwk::IdGenerator.instance.generate("irm_object_attributes")
        case cux[2].to_s
          when "0"
            cux_category = "TEXT"
          when "1"
            cux_category = "NUMBER"
          when "3"
            cux_category = "PICK_LIST"
            pick_list_options = cux[7]
          when "8"
            cux_category = "DATE"
          else
            nil
        end

        execute(%Q(INSERT INTO tmp_irm_object_attributes (id, opu_id, business_object_id, attribute_name, attribute_type, field_type, category,
                                                          data_type, data_null_flag, data_length, data_default_value, pick_list_options, data_extra_info,
                                                          external_system_id, display_sequence, status_code, created_by, updated_by, created_at, updated_at)
                                                          VALUES
                                                        ('#{cux_field_id}', '#{opu_id}', '000d00024G4OI8rfj2xjPs', 'sattribute#{attribute_count.to_s}', 'TABLE_COLUMN', 'SYSTEM_CUX_FIELD', '#{cux_category}',
                                                          '#{data_type}', '#{data_null_flag}', '#{data_length}', '#{data_default_value}', '#{pick_list_options}', '#{data_extra_info}',
                                                          '#{ext_id}', '#{cux[9]}', 'ENABLED', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}')
        ))
        execute(%Q(INSERT INTO tmp_irm_object_attributes_tl (id, opu_id, object_attribute_id, name, description,
                                                              status_code, created_by, updated_by, created_at, updated_at, language, source_lang)
                                                            VALUES
                                                            ('#{Fwk::IdGenerator.instance.generate("irm_object_attributes_tl")}', '#{opu}', '#{cux_field_id}', '#{cux[1]}', '#{cux[1]}',
                                                              'ENABLED', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}', 'zh', 'en')))
        execute(%Q(INSERT INTO tmp_irm_object_attributes_tl (id, opu_id, object_attribute_id, name, description,
                                                              status_code, created_by, updated_by, created_at, updated_at, language, source_lang)
                                                            VALUES
                                                            ('#{Fwk::IdGenerator.instance.generate("irm_object_attributes_tl")}', '#{opu}', '#{cux_field_id}', '#{cux[1]}', '#{cux[1]}',
                                                              'ENABLED', '#{r[5]}', '#{r[6]}', '#{r[7]}', '#{r[8]}', 'en', 'en')))
        attribute_count = attribute_count + 1
      end
    end




    close_reason = Icm::CloseReason.multilingual.where("close_code = ?", "NORMAL_CLOSE").first
    # move category
    ir_category_result = execute(%Q(SELECT mc.id "0", mc.project_id "1", mc.name "2", -1 '3', -1 '4', now() '5', now() '6'
                                    FROM mantis_category_table mc WHERE LENGTH(mc.name) > 0 ))

    ir_category_result.each do |c|
      category_id = Fwk::IdGenerator.instance.generate("icm_incident_categories")
      cn_id = Fwk::IdGenerator.instance.generate("icm_incident_categories_tl")
      en_id = Fwk::IdGenerator.instance.generate("icm_incident_categories_tl")
      cs_id = Fwk::IdGenerator.instance.generate("icm_incident_category_systems")
      es = execute(%Q(SELECT id FROM tmp_irm_external_systems es WHERE es.external_system_code = '#{c[1]}'))
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



    #move request
    ir_result = execute(%Q(SELECT mb.id '0', mb.project_id '1', mb.reporter_id '2', mb.handler_id '3', ipc.weight_values '4', iis.id '5', mb.bug_text_id '6',
                            mb.summary '7', tic.id '8', date_add('1970-01-01 08:00:00', interval mb.date_submitted second) '9',
                            date_add('1970-01-01 08:00:00', interval mb.last_updated second) '10', mbt.description '11',
                            mbt.additional_information '12', IF(mcs.value NOT LIKE '%NOT%', IF(length(mcs.value)>0, 'Y', 'N'), 'N') '13', mcs_p.value '14', p_sub.id '15',
                            p_sup.id '16', es.id '17', tio.id '18', tic.id '19', -1 '20', -1 '21', now() '22', now() '23',
                            ipc.id '24', iir.id '25', iuc.id '26', mb.status '27', mbt.additional_information '28', mb.priority '29', mb.severity '30'
                            FROM mantis_bug_table mb
                            LEFT OUTER JOIN (mantis_custom_field_table mc, mantis_custom_field_string_table mcs) ON (mc.id = mcs.field_id AND mcs.bug_id = mb.id AND mc.name = 'HOTLINE')
                            LEFT OUTER JOIN (mantis_custom_field_table mc_p, mantis_custom_field_string_table mcs_p) ON
                                            (mc_p.id = mcs_p.field_id AND mcs_p.bug_id = mb.id AND (mc_p.name = '所用工时数（单位：人时）' OR mc_p.name = 'Total Working Hours'))
                            LEFT OUTER JOIN (tmp_irm_organizations tio) ON (tio.short_name = mb.project_id)
                            LEFT OUTER JOIN (tmp_icm_incident_categories tic) ON (tic.code = mb.category_id)
                            LEFT OUTER JOIN (tmp_irm_people p_sub) ON (p_sub.identity_id = mb.`reporter_id`)
                            LEFT OUTER JOIN (tmp_irm_people p_sup) ON (p_sup.identity_id = mb.`handler_id`)
                            LEFT OUTER JOIN (tmp_irm_external_systems es) ON (es.external_system_code = mb.project_id)
                            LEFT OUTER JOIN (icm_incident_statuses iis) ON (iis.incident_status_code = CASE mb.status
                            WHEN '10' THEN '10'
                            WHEN '20' THEN '20'
                            WHEN '30' THEN '30'
                            WHEN '40' THEN '40'
                            WHEN '50' THEN '50'
                            WHEN '80' THEN '80'
                            WHEN '90' THEN '90'
                            ELSE '-1' END)
                            LEFT OUTER JOIN icm_impact_ranges iir ON iir.impact_code = mb.severity
                            LEFT OUTER JOIN icm_urgence_codes iuc ON iuc.urgency_code = mb.priority
                            LEFT OUTER JOIN (icm_priority_codes ipc)
                            ON (ipc.weight_values = CASE mb.priority
                            WHEN '10' THEN '1'
                            WHEN '20' THEN '2'
                            WHEN '30' THEN '3'
                            WHEN '40' THEN '4'
                            WHEN '50' THEN '5'
                            WHEN '60' THEN '6'
                            ELSE '5' END)
                            , mantis_bug_text_table mbt
                            WHERE mb.bug_text_id = mbt.id
                            ))


    ir_result.each do |r|
      ir_id = Fwk::IdGenerator.instance.generate("icm_incident_requests")
      pt = r[14]

      #begin
      #  if (pt.end_with?("H") or pt.end_with?("小时")) and pt.gsub("小时", '').index(/[\u4e00-\u9fa5]/).nil? and pt.index("+").nil?
      #    pt = pt.gsub("H", '').gsub(" ", '').gsub("小时", '')
      #  elsif (pt.end_with?("M") or pt.end_with?("分钟")) and pt.end_with?("分钟") and pt.gsub("分钟", '').index(/[\u4e00-\u9fa5]/).nil? and pt.index("+").nil?
      #    pt = (pt.gsub("M", '').gsub("分钟", '').gsub(" ", '').to_f/60.to_f * 1000).round/1000.0
      #  elsif pt.end_with?("D") and pt.gsub("D", '').index(/[\u4e00-\u9fa5]/).nil? and pt.index("+").nil?
      #    pt = (pt.gsub("D", '').gsub(" ", '').to_f * 8.to_f * 1000).round/1000.0
      #  elsif !pt.match(/^[0-9]+(.[0-9]{1,3})?$/).nil?
      #    pt = pt.to_i
      #  else
      #    pt = -1
      #  end
      #rescue
      #  pt = -2
      #end if pt.present?
      title = r[7]
      title = r[7].gsub("'", /\\'/.source)
      content = r[11]
      content = r[11].gsub("'", /\\'/.source)
      content = "<pre>" + content + "</pre>"
      close_reason_id = ''
      if r[27] == "90"
        close_reason_id = close_reason.id
      end
      #0510Irm
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
                VALUES ('REQUESTED_TO_PERFORM', 'CUSTOMER_SUBMIT', '#{ir_id}','#{r[0]}', '#{title}','#{content}','#{r[13]}',
                        '#{r[17]}','#{r[8]}','#{r[15]}','#{r[18]}','#{r[15]}','#{r[4]}','#{r[15]}','#{contact_number}',
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

      #add workloads
      begin
        pt = r[14].slice(',')
        if pt.nil?
          pt = r[14]
          if (pt.end_with?("H") or pt.end_with?("小时")) and pt.gsub("小时", '').index(/[\u4e00-\u9fa5]/).nil? and pt.index("+").nil?
            pt = pt.gsub("H", '').gsub(" ", '').gsub("小时", '')
          elsif (pt.end_with?("M") or pt.end_with?("分钟")) and pt.end_with?("分钟") and pt.gsub("分钟", '').index(/[\u4e00-\u9fa5]/).nil? and pt.index("+").nil?
            pt = (pt.gsub("M", '').gsub("分钟", '').gsub(" ", '').to_f/60.to_f * 1000).round/1000.0
          elsif pt.end_with?("D") and pt.gsub("D", '').index(/[\u4e00-\u9fa5]/).nil? and pt.index("+").nil?
            pt = (pt.gsub("D", '').gsub(" ", '').to_f * 8.to_f * 1000).round/1000.0
          elsif !pt.match(/^[0-9]+(.[0-9]{1,3})?$/).nil?
            pt = pt.to_f
          else
            pt = -1
          end

          execute(%Q(INSERT INTO tmp_icm_incident_workloads (id, incident_request_id, person_id, real_processing_time, workload_type,
                        status_code, created_by, updated_by, created_at, updated_at)
                        VALUES ('#{Fwk::IdGenerator.instance.generate("icm_incident_workloads")}', '#{ir_id}', '#{r[16]}', '#{pt}', 'REMOTE',
                        'ENABLED', '#{r[20]}','#{r[21]}','#{r[22]}','#{r[23]}')
                        )) if pt.to_f > 0
        else
          pt.each do |p|
            data = p.gsub(" ", "").slice(':')
            data.each do |d|
              person = execute(%Q(SELECT ip.id FROM tmp_irm_people ip WHERE ip.fullname = '#{d[0]}')) #0531
              if person.size > 0
                pt = d[1]
                if (pt.end_with?("H") or pt.end_with?("小时")) and pt.gsub("小时", '').index(/[\u4e00-\u9fa5]/).nil? and pt.index("+").nil?
                  pt = pt.gsub("H", '').gsub(" ", '').gsub("小时", '')
                elsif (pt.end_with?("M") or pt.end_with?("分钟")) and pt.end_with?("分钟") and pt.gsub("分钟", '').index(/[\u4e00-\u9fa5]/).nil? and pt.index("+").nil?
                  pt = (pt.gsub("M", '').gsub("分钟", '').gsub(" ", '').to_f/60.to_f * 1000).round/1000.0
                elsif pt.end_with?("D") and pt.gsub("D", '').index(/[\u4e00-\u9fa5]/).nil? and pt.index("+").nil?
                  pt = (pt.gsub("D", '').gsub(" ", '').to_f * 8.to_f * 1000).round/1000.0
                elsif !pt.match(/^[0-9]+(.[0-9]{1,3})?$/).nil?
                  pt = pt.to_f
                else
                  pt = -1
                end
                execute(%Q(INSERT INTO tmp_icm_incident_workloads (id, opu_id, incident_request_id, person_id, real_processing_time,workload_type,
                              status_code, created_by, updated_by, created_at, updated_at)
                              VALUES ('#{Fwk::IdGenerator.instance.generate("icm_incident_workloads")}', '#{opu}', '#{r[0]}', '#{person.first[0]}', '#{pt}', 'REMOTE',
                              'ENABLED', '#{r[20]}','#{r[21]}','#{r[22]}','#{r[23]}')
                              )) if pt.to_f > 0
              end
            end
          end
        end
      rescue
        #execute(%Q(INSERT INTO tmp_icm_incident_workloads (id, opu_id, incident_request_id, person_id, real_processing_time,
        #              status_code, created_by, updated_by, created_at, updated_at)
        #              VALUES ('#{Fwk::IdGenerator.instance.generate("icm_incident_workloads")}', '#{opu}', '#{ir_id}', '#{r[16]}', '-3',
        #              'ENABLED', '#{r[20]}','#{r[21]}','#{r[22]}','#{r[23]}')
        #              ))
      end unless r[14].nil?

      #move cux field value
      cux_fields = execute(%Q(SELECT mcfs.field_id '0', mcfs.bug_id '1', mcfs.value '2', ioa.attribute_name '3', mcf.type '4'
                              FROM mantis_custom_field_string_table mcfs, tmp_irm_object_attributes ioa, mantis_custom_field_table mcf
                              WHERE mcfs.bug_id = '#{r[0]}' AND mcfs.field_id = ioa.data_extra_info AND ioa.external_system_id = '#{r[17]}'
                                    AND mcf.id = mcfs.field_id))
      cux_fields.each do |cf|
        value = cf[2]
        if cf[4] == '8'
          cux_fields_ex = execute(%Q(SELECT mcfs.field_id '0', mcfs.bug_id '1', date_add('1970-01-01 08:00:00', interval mcfs.value second) '2', ioa.attribute_name '3', mcf.type '4'
                          FROM mantis_custom_field_string_table mcfs, tmp_irm_object_attributes ioa, mantis_custom_field_table mcf
                          WHERE mcfs.bug_id = '#{r[0]}' AND mcfs.field_id = ioa.data_extra_info AND ioa.external_system_id = '#{r[17]}'
                                AND mcf.id = mcfs.field_id))
          value = cux_fields_ex.first[2]
        end
        execute(%Q(UPDATE tmp_icm_incident_requests SET #{cf[3]} = '#{value}' WHERE request_number = '#{r[0].to_s}'))
      end

      #create close journal, journal elapse, journal history, journal

      #journal
      journal = execute(%Q(SELECT mbn.bug_id '0', ip.id '1', mbnt.note '2', date_add('1970-01-01 08:00:00', interval mbn.last_modified second) '3',
                            date_add('1970-01-01 08:00:00', interval mbn.date_submitted second) '4',
                            (SELECT MAX(date_add('1970-01-01 08:00:00', interval last_mbn.last_modified second))
                            FROM mantis_bugnote_table last_mbn WHERE last_mbn.bug_id = mbn.bug_id  AND last_mbn.last_modified < mbn.last_modified) '5', mbnt.id '6'
                            FROM mantis_bugnote_table mbn, mantis_bugnote_text_table mbnt, tmp_irm_people ip
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
                                    FROM mantis_bug_history_table mbh, tmp_irm_people ip
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
                old_value = execute(%Q(SELECT ip.id FROM tmp_irm_people ip WHERE ip.identity_id = '#{old_value}')).first[0] if old_value.present?
              rescue
              end
              begin
                new_value = execute(%Q(SELECT ip.id FROM tmp_irm_people ip WHERE ip.identity_id = '#{new_value}')).first[0] if new_value.present?
              rescue
              end
              action_type = 'ASSIGN' if (old_value.blank? ||old_value == 0) && !new_value.blank?
              action_type = 'PASS' if !old_value.blank? && !new_value.blank?
            when "priority"
              field_name = "priority_id"
              case old_value
                when '10'
                  old_value = '1'
                when '20'
                  old_value = '2'
                when '30'
                  old_value = '3'
                when '40'
                  old_value = '4'
                when '50'
                  old_value = '5'
                when '60'
                  old_value = '6'
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
                old_value = execute(%Q(SELECT ip.id FROM tmp_irm_people ip WHERE ip.identity_id = '#{old_value}')).first[0] if old_value.present?
              rescue
              end
              begin
                new_value = execute(%Q(SELECT ip.id FROM tmp_irm_people ip WHERE ip.identity_id = '#{new_value}')).first[0] if new_value.present?
              rescue
              end
            when "status"
              field_name = "incident_status_id"
              case old_value.to_s
                when '10'
                  old_value = '10'
                when '20'
                  old_value = '20'
                when '30'
                  old_value = '30'
                when '40'
                  old_value = '40'
                when '50'
                  old_value = '50'
                when '80'
                  old_value = '80'
                when '90'
                  old_value = '90'
              end if old_value.present?
              old_value = execute(%Q(SELECT iis.id FROM icm_incident_statuses iis WHERE iis.incident_status_code = '#{old_value}')).first[0] if old_value.present?
              case new_value.to_s
                when '10'
                  new_value = '10'
                when '20'
                  new_value = '20'
                when '30'
                  new_value = '30'
                when '40'
                  new_value = '40'
                when '50'
                  new_value = '50'
                when '80'
                  new_value = '80'
                when '90'
                  new_value = '90'
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
                    old_value = execute(%Q(SELECT ip.id FROM tmp_irm_people ip WHERE ip.identity_id = '#{old_value}')).first[0] if old_value.present?
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

    #修正history中request relation的new value数据
    fix_his = execute(%Q(SELECT t.id "0", t.new_value "1" FROM  tmp_icm_incident_histories t WHERE t.property_key IN ('add_relation','remove_relation')))
    fix_his.each do |h|
      r = execute(%Q(SELECT t.id "0" FROM  tmp_icm_incident_requests t WHERE t.request_number = '#{h[1]}'))
      if r.size > 0
        execute(%Q(UPDATE tmp_icm_incident_histories SET new_value = '#{r.first[0]}' WHERE id = '#{h[0]}'))
      end
    end

    rel_result = execute(%Q(SELECT mrt.relationship_type '0', ir_source.id '1', ir_target.id '2', now() '3'
                                FROM mantis_bug_relationship_table mrt, tmp_icm_incident_requests ir_source, tmp_icm_incident_requests ir_target
                                WHERE mrt.source_bug_id = ir_source.request_number
                                AND mrt.destination_bug_id = ir_target.request_number))
    rel_result.each do |rr|
      rr_id = Fwk::IdGenerator.instance.generate("icm_incident_request_relations")
      r_type = ''
      case rr[0].to_s
        when '0' || '4'
          r_type = 'SAME'
        when '1'
          r_type = 'RELATION'
        when '2'
          r_type = 'CHILD'
        when '3'
          r_type = 'PARENT'
        else
          r_type = 'RELATION'
      end
      execute(%Q(INSERT INTO tmp_icm_incident_request_relations (id, opu_id, source_id, target_id, relation_type,
                                      status_code, created_by, updated_by, created_at, updated_at)
                         VALUES ('#{rr_id}', '#{opu}', '#{rr[1]}', '#{rr[2]}', '#{r_type}', 'ENABLED', '-1', '-1', '#{rr[3]}', '#{rr[3]}')))
    end
    #mantis monitors
    wat_result = execute(%Q(SELECT ip.id '0', ir.id '1', now() '2', ir.requested_by '3' FROM mantis_bug_monitor_table mbmt, tmp_irm_people ip,
                                tmp_icm_incident_requests ir WHERE mbmt.user_id = ip.identity_id AND mbmt.bug_id = ir.request_number
                                ))
    wat_result.each do |wat|
      ex = execute(%Q(SELECT iw.id FROM tmp_irm_watchers iw WHERE iw.watchable_id = '#{wat[1]}' AND iw.member_id = '#{wat[0]}'))
      next if ex.any?
      execute(%Q(INSERT INTO tmp_irm_watchers (id, opu_id, watchable_id, watchable_type, member_id,
                        member_type, deletable_flag, created_by, updated_by, created_at, updated_at)
                VALUES ('#{Fwk::IdGenerator.instance.generate("irm_watchers")}', '#{opu}', '#{wat[1]}', 'Icm::IncidentRequest', '#{wat[0]}', 'Irm::Person',
                        'Y', '#{wat[3]}', '#{wat[3]}', '#{wat[2]}', '#{wat[2]}')
                ))
    end


    # move attachment
    rec = 1
    inv = 100
    while true do
      file_result = execute(%Q(SELECT mbf.content '0', mbf.filename '1', ir.id '2', mbf.title '3', IFNULL(ip.id, 0) '4',
date_add('1970-01-01 08:00:00', interval mbf.date_added second) '5', mbf.id '6', mbf.file_type '7', mbf.filesize '8'
FROM mantis_bug_file_table mbf
LEFT OUTER JOIN (tmp_irm_people ip) ON (ip.identity_id = mbf.user_id),
tmp_icm_incident_requests ir WHERE ir.request_number = mbf.bug_id LIMIT #{inv} OFFSET #{rec}
                            ))
      break unless file_result.any?
      rec = rec + inv
      file_result.each do |fr|
        f=File.open("#{Rails.root}/public/tmp/#{fr[1]}","w+")
        begin
          f.write(StringIO.new(fr[0], "rb").read.force_encoding('UTF-8'))
          container = Irm::Attachment.create(:id => Fwk::IdGenerator.instance.generate("irm_attachments"),
                                             :opu_id => opu,
                                             :status_code => "ENABLED",
                                             :updated_by => fr[4],
                                             :created_by => fr[4],
                                             :created_at => fr[5],
                                             :updated_at => fr[5])
          t = Irm::AttachmentVersion.create(:id => Fwk::IdGenerator.instance.generate("irm_attachment_versions"),
                                            :opu_id => opu,
                                            :attachment_id => container.id,
                                            :description => fr[3],
                                            :image_flag => "N",
                                            :data => f,
                                            :source_type => 'Icm::IncidentRequest',
                                            :source_id => fr[2],
                                            :data_file_name => fr[1],
                                            :data_content_type => fr[7],
                                            :data_file_size => fr[8],
                                            :data_updated_at => fr[5],
                                            :status_code => "ENABLED",
                                            :updated_by => fr[4],
                                            :created_by => fr[4],
                                            :created_at => fr[5],
                                            :updated_at => fr[5])
          Irm::AttachmentVersion.update_attachment_by_version(container,t)

          f.close
        rescue
          f.close
        end
      end
    end
  end

  def down
  end
end
