class Htc::HitachiTicketStatisReport < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}



    people = Irm::Person.where("1=1").
        select("#{Irm::Person.table_name}.*")

    support_group_ids = []
    if params[:support_group_id].present? && params[:support_group_id].size > 0 && params[:support_group_id][0].present?
      people = people.
          where("EXISTS (SELECT * FROM #{Irm::GroupMember.table_name} gm, icm_support_groups ig WHERE gm.person_id = #{Irm::Person.table_name}.id AND ig.group_id = gm.group_id AND ig.id IN (?))",
                params[:support_group_id] + [])
    else
      people = people.where("EXISTS (SELECT * FROM #{Irm::GroupMember.table_name} gm WHERE gm.person_id = #{Irm::Person.table_name}.id)")
    end

    open_status = Icm::IncidentStatus.where("incident_status_code NOT IN (?)", ["CLOSED", "SOLVED"]).collect(&:id)
    resolved_status = Icm::IncidentStatus.where("incident_status_code IN (?)", ["SOLVED"]).collect(&:id)
    close_status = Icm::IncidentStatus.where("incident_status_code IN (?)", ["CLOSED"]).collect(&:id)

    on_hand_open = Icm::IncidentRequest.
        where("incident_status_id IN (?)", open_status).
        select("count(1) on_hand_open")

    deposit = Icm::IncidentRequest.
        where("incident_status_id IN (?)", open_status).
        where("last_response_date < ?", Time.now - 3.days).
        select("count(1) deposit")

    resolved = Icm::IncidentRequest.
            where("incident_status_id IN (?)", resolved_status).
            where("last_response_date < ?", Time.now - 3.days).
            select("count(1) resolved")


    hour_maintainance = Icm::IncidentRequest.
        where("incident_status_id IN (?) AND (cux_resolve_hours IS NULL OR (attribute1 LIKE ? AND (sattribute17 IS NULL OR sattribute19 IS NULL OR sattribute18 IS NULL OR sattribute20 IS NULL)))",
              close_status, "%System Bug%").
        where("NOT EXISTS (SELECT * FROM icm_incident_journals ij WHERE ij.incident_request_id = icm_incident_requests.id AND ij.reply_type = ? AND ij.created_at < ?)",
              "CLOSE", Date.strptime("2012-11-01", '%Y-%m-%d')).
        select("count(1) hour_maintainance")

    root_cause = Icm::IncidentRequest.
        where("incident_status_id IN (?)", close_status).
        where("NOT EXISTS (SELECT * FROM icm_incident_journals ij WHERE ij.incident_request_id = icm_incident_requests.id AND ij.reply_type = ? AND ij.created_at < ?)",
              "CLOSE", Date.strptime("2013-03-01", '%Y-%m-%d')).
        where("attribute1 IS NULL").
        select("count(1) root_cause")

    datas = []
    headers = [
               "Owner",
               "On-hand Open",
               "Deposit",
               "Resolved before > 3 days",
               "No Hour Maintainance",
               "No Root Cause"
               ]

    people.each do |p|
      data = Array.new(6)
      data[0] = p[:full_name]
      p_on_hand_open = on_hand_open.where("support_person_id = ?", p.id)
      data[1] = p_on_hand_open.first[:on_hand_open] == 0 ? "-" : p_on_hand_open.first[:on_hand_open]
      p_deposit = deposit.where("support_person_id = ?", p.id)
      data[2] = p_deposit.first[:deposit] == 0 ? "-" : p_deposit.first[:deposit]
      p_resolved = resolved.where("support_person_id = ?", p.id)
      data[3] = p_resolved.first[:resolved] == 0 ? "-" : p_resolved.first[:resolved]
      p_hour_maintainance = hour_maintainance.where("support_person_id = ?", p.id)
      data[4] = p_hour_maintainance.first[:hour_maintainance] == 0 ? "-" : p_hour_maintainance.first[:hour_maintainance]
      p_root_cause = root_cause.where("support_person_id = ?", p.id)
      data[5] = p_root_cause.first[:root_cause] == 0 ? "-" : p_root_cause.first[:root_cause]

      datas << data
    end

    {:datas=>datas,:headers=>headers,:params=>params}
  end

  def to_xls(params)
    columns = []

    result = data(params)

    result[:headers].each_with_index do |sh,index|
      columns << {:key=>index.to_s.to_sym,:label=>sh}
    end

    excel_data = []
    result[:datas].each_with_index do |data,index|
      excel_data << data.to_cus_hash
    end

    excel_data.to_xls(columns,{})
  end
end
