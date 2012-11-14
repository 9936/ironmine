# -*- coding: utf-8 -*-
class UploadIssueForGscm < ActiveRecord::Migration
  def up
    opu = Irm::OperationUnit.where("short_name = ?", "Hand").first.id
    last_update_mark = "-2"
    begin
      execute("DROP TABLE tmp_icm_incident_requests")
    rescue
      nil
    end

    begin
      execute("DROP TABLE tmp_icm_incident_journals")
    rescue
      nil
    end

    begin
      execute("DROP TABLE tmp_icm_incident_histories")
    rescue
      nil
    end

    begin
      execute("DROP TABLE tmp_icm_incident_journal_elapses")
    rescue
      nil
    end

    begin
      execute("DROP TABLE tmp_irm_watchers")
    rescue
      nil
    end

    execute("CREATE TABLE tmp_icm_incident_requests LIKE icm_incident_requests")
    execute("CREATE TABLE tmp_icm_incident_journals LIKE icm_incident_journals")
    execute("CREATE TABLE tmp_icm_incident_histories LIKE icm_incident_histories")
    execute("CREATE TABLE tmp_icm_incident_journal_elapses LIKE icm_incident_journal_elapses")
    execute("CREATE TABLE tmp_irm_watchers LIKE irm_watchers")


    issue_list = execute(%Q(SELECT Number '0', Title '1', Summary '2', System '3', Category '4',
                                `Sub Category` '5', Reply '6', `Reply Date` '7', Priority '8', `Root Cause` '9', `Status` '10',
                                Submitter '11', `Contact Info_` '12', `Support group` '13', Supporter '14', `Submit date` '15',
                                `Last Response` '16', `Real Response Date` '17', `Real Submit Date` '18', `Real Resolve Date` '19',
                                `Resolve Hours` '20', `Real Close Date` '21', `Response Hours` '22'
                                FROM issue_list il))

    issue_list.each do |r|
      request_number = Irm::Sequence.nextval("Icm::IncidentRequest", opu)
      request_id = Fwk::IdGenerator.instance.generate("icm_incident_requests")
      external_system_id = Irm::ExternalSystem.where("external_system_code = ?", 'GSCM').first.id

      category_id = Icm::IncidentCategory.
          joins(",#{Icm::IncidentCategoriesTl.table_name} ict").
          where("ict.name = ?", r[4]).
          where("ict.incident_category_id = #{Icm::IncidentCategory.table_name}.id").
          where("ict.language = 'en'").first.id

      subcategory_id = ''
      subcategory = Icm::IncidentSubCategory.
                joins(",#{Icm::IncidentSubCategoriesTl.table_name} ict").
                where("ict.name = ?", r[5]).
                where("ict.incident_sub_category_id = #{Icm::IncidentSubCategory.table_name}.id").
                where("ict.language = 'en'")

      subcategory_id = subcategory.first.id if subcategory.any?

      submitter = Irm::Person.where("full_name = ?", r[11]).first
      priority = Icm::PriorityCode.
          joins(",#{Icm::PriorityCodesTl.table_name} pct").
          where("pct.name = ?", r[8]).
          where("pct.language = 'en'").
          where("pct.priority_code_id = #{Icm::PriorityCode.table_name}.id").
          first

      status = Icm::IncidentStatus.
          joins(",#{Icm::IncidentStatusesTl.table_name} ist").
          where("ist.incident_status_id = #{Icm::IncidentStatus.table_name}.id").
          where("ist.language = ?", "en").
          where("ist.name = ?", r[10]).
          first

      urgence = Icm::UrgenceCode.where("weight_values = ?", priority.weight_values).first

      support_group = Icm::SupportGroup.
          joins(",icm_support_groups_vl sgv").
          where("sgv.id = #{Icm::SupportGroup.table_name}.id").
          where("sgv.name = ?", r[13]).first

      supporter = Irm::Person.where("full_name = ?", r[14]).first
      close_reason_id = ""
      close_reason_id = "000900075CLlbiaXnFab8C" if status.incident_status_code.eql?("CLOSED")
      default_impact_range_id = "000C00081LfL1v88KZbqPg"

      title = r[1]
      title = r[1].gsub("'", /\\'/.source)
      content = r[2]
      content = r[2].gsub("'", /\\'/.source)
      content = "<pre>" + content + "</pre>"
      # insert incident request
      execute(%Q(INSERT INTO tmp_icm_incident_requests (request_type_code, report_source_code, id, request_number, title, summary,
                  external_system_id, incident_category_id, incident_sub_category_id, requested_by, organization_id, submitted_by,
                  weight_value, contact_id, contact_number,
                  incident_status_id, priority_id, impact_range_id, urgence_id, close_reason_id,
                  support_group_id, support_person_id,
                  submitted_date,reply_count, last_request_date, last_response_date, opu_id, status_code, created_by, updated_by, created_at, updated_at)
                VALUES ('REQUESTED_TO_PERFORM', 'CUSTOMER_SUBMIT', '#{request_id}','#{request_number}', '#{title}','#{content}',
                        '#{external_system_id}','#{category_id}','#{subcategory_id}','#{submitter.id}','#{submitter.organization_id}','#{submitter.id}',
                        '#{priority.weight_values}', '#{submitter.id}','#{submitter.bussiness_phone}',
                        '#{status.id}','#{priority.id}','#{default_impact_range_id}','#{urgence.id}','#{close_reason_id}',
                        '#{support_group.id}', '#{supporter.id}',
                        '#{r[15]}','1','#{r[16]}', '#{r[16]}', '#{opu}', 'ENABLED', '#{submitter.id}','#{last_update_mark}','#{r[15]}','#{r[16]}')
                ))

      # insert incident journal
      j_id = Fwk::IdGenerator.instance.generate("icm_incident_journals")
      j_number = Irm::Sequence.nextval("Icm::IncidentJournal", opu)
      note = r[6]
      note = r[6].gsub("\\", /\\\\/.source).gsub("'", /\\'/.source)
      note = "<pre>" + note + "</pre>"
      execute(%Q(INSERT INTO tmp_icm_incident_journals (id, journal_number, opu_id, incident_request_id, reply_type, replied_by, message_body,
                            status_code, created_by, updated_by, created_at, updated_at)
                  VALUES ('#{j_id}', '#{j_number}', '#{opu}', '#{request_id}', 'OTHER_REPLY',
                            '#{supporter.id}', '#{note}', 'ENABLED', '#{supporter.id}', '#{last_update_mark}', '#{r[7]}', '#{r[7]}')
                  ))

      #history
      execute(%Q(INSERT INTO tmp_icm_incident_histories (id, opu_id, request_id, journal_id, property_key, old_value, new_value,
                            status_code, created_by, updated_by, created_at, updated_at)
                     VALUES ('#{Fwk::IdGenerator.instance.generate("icm_incident_histories")}', '#{opu}', '#{request_id}',
                            '#{j_id}', 'new_reply', '', '#{note}',
                            'ENABLED', '#{supporter.id}', '#{last_update_mark}', '#{r[7]}', '#{r[7]}')))

      #journal elapse
      execute(%Q(INSERT INTO tmp_icm_incident_journal_elapses (id, opu_id, incident_journal_id, elapse_type,
                            support_group_id, incident_status_id, start_at, end_at, distance, real_distance,
                            status_code, created_by, updated_by, created_at, updated_at)
                            VALUES ('#{Fwk::IdGenerator.instance.generate("icm_incident_journal_elapses")}', '#{opu}', '#{j_id}', 'OTHER_REPLY',
                            '','','#{r[15]}', '#{r[7]}', '0', '0',
                            'ENABLED', '#{supporter.id}', '#{last_update_mark}', '#{r[7]}', '#{r[7]}')
                            ))
      #将进行过回复的人员都添加进watcher
      ex_support = execute(%Q(SELECT iw.id FROM tmp_irm_watchers iw WHERE iw.watchable_id = '#{request_id}' AND iw.member_id = '#{supporter.id}'))
      execute(%Q(INSERT INTO tmp_irm_watchers (id, opu_id, watchable_id, watchable_type, member_id,
                        member_type, deletable_flag, created_by, updated_by, created_at, updated_at)
                VALUES ('#{Fwk::IdGenerator.instance.generate("irm_watchers")}', '#{opu}', '#{request_id}', 'Icm::IncidentRequest', '#{supporter.id}', 'Irm::Person',
                        'N', '#{supporter.id}', '#{last_update_mark}', '#{r[7]}', '#{r[7]}')
                )) unless ex_support.any?

      ex_submit = execute(%Q(SELECT iw.id FROM tmp_irm_watchers iw WHERE iw.watchable_id = '#{request_id}' AND iw.member_id = '#{submitter.id}'))
      execute(%Q(INSERT INTO tmp_irm_watchers (id, opu_id, watchable_id, watchable_type, member_id,
                        member_type, deletable_flag, created_by, updated_by, created_at, updated_at)
                VALUES ('#{Fwk::IdGenerator.instance.generate("irm_watchers")}', '#{opu}', '#{request_id}', 'Icm::IncidentRequest', '#{submitter.id}', 'Irm::Person',
                        'N', '#{submitter.id}', '#{last_update_mark}', '#{r[7]}', '#{r[7]}')
                )) unless ex_submit.any?

      # create ticket history
      execute(%Q(INSERT INTO tmp_icm_incident_histories (id, opu_id, request_id, journal_id, property_key, old_value, new_value,
                            status_code, created_by, updated_by, created_at, updated_at)
                     VALUES ('#{Fwk::IdGenerator.instance.generate("icm_incident_histories")}', '#{opu}', '#{request_id}',
                            '', 'incident_request_id', '#{r[7]}', '',
                            'ENABLED', '#{submitter.id}', '#{last_update_mark}', '#{r[7]}', '#{r[7]}')))

      # close ticket history
      if status.incident_status_code.eql?("CLOSED")
        j_id = Fwk::IdGenerator.instance.generate("icm_incident_journals")
        execute(%Q(INSERT INTO tmp_icm_incident_journals (id, opu_id, incident_request_id, reply_type, replied_by, message_body,
                              status_code, created_by, updated_by, created_at, updated_at)
                    VALUES ('#{j_id}', '#{opu}', '#{request_id}', 'CLOSE',
                              '#{supporter.id}', '', 'ENABLED', '#{submitter.id}', '#{last_update_mark}', '#{r[7]}', '#{r[7]}')
                    ))
        execute(%Q(INSERT INTO tmp_icm_incident_histories (id, opu_id, request_id, journal_id, property_key, old_value, new_value,
                              status_code, created_by, updated_by, created_at, updated_at)
                       VALUES ('#{Fwk::IdGenerator.instance.generate("icm_incident_histories")}', '#{opu}', '#{request_id}',
                              '#{j_id}', 'status', 'NEW', 'CLOSE',
                              'ENABLED', '#{submitter.id}', '#{last_update_mark}', '#{r[7]}', '#{r[7]}')))
      end
    end

    execute("INSERT INTO icm_incident_requests SELECT * FROM tmp_icm_incident_requests")
    execute("INSERT INTO icm_incident_journals SELECT * FROM tmp_icm_incident_journals")
    execute("INSERT INTO icm_incident_histories SELECT * FROM tmp_icm_incident_histories")
    execute("INSERT INTO icm_incident_journal_elapses SELECT * FROM tmp_icm_incident_journal_elapses")
    execute("INSERT INTO irm_watchers SELECT * FROM tmp_irm_watchers")
  end

  def down
  end
end