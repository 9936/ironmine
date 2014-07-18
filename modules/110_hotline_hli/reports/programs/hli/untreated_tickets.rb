# -*- coding:utf-8 -*-
class Hli::UntreatedTickets < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    group_id = params[:group]

    start_date = params[:start_date]
    unless params[:start_date].present?
      start_date = "1970-1-1"
    end
    end_date = params[:end_date]
    unless params[:end_date].present?
      end_date = "2099-1-1"
    end

    member = Irm::Person.
        select_all.
        joins(",#{Irm::GroupMember.table_name} gm").
        where("gm.person_id = #{Irm::Person.table_name}.id").
        where("gm.group_id = ?", group_id).
        select(%Q((SELECT
            COUNT(1)
        FROM
            icm_incident_requests ir1
        WHERE
            ir1.hotline = 'Y' AND
            EXISTS( SELECT
                    1
                FROM
                    icm_incident_journals ij1
                WHERE
                    ij1.incident_request_id = ir1.id
                        AND ij1.reply_type = 'CLOSE' AND
                date_format(ij1.created_at, '%Y-%m-%d') <= '#{Date.strptime("#{end_date}", '%Y-%m-%d').strftime("%Y-%m-%d")}' AND
                date_format(ij1.created_at, '%Y-%m-%d') >= '#{Date.strptime("#{start_date}", '%Y-%m-%d').strftime("%Y-%m-%d")}')
                AND ir1.support_person_id = #{Irm::Person.table_name}.id
                ) c_close)).
        select(%Q((SELECT
            group_concat(concat(ir1.request_number, '-', uv.name))
        FROM
            icm_incident_requests ir1, icm_urgence_codes_vl uv
        WHERE
            ir1.hotline = 'Y' AND uv.language = 'zh' AND uv.id = ir1.urgence_id AND
            EXISTS( SELECT
                    1
                FROM
                    icm_incident_journals ij1
                WHERE
                    ij1.incident_request_id = ir1.id
                        AND ij1.reply_type = 'CLOSE' AND
                date_format(ij1.created_at, '%Y-%m-%d') <= '#{Date.strptime("#{end_date}", '%Y-%m-%d').strftime("%Y-%m-%d")}' AND
                date_format(ij1.created_at, '%Y-%m-%d') >= '#{Date.strptime("#{start_date}", '%Y-%m-%d').strftime("%Y-%m-%d")}')
                AND ir1.support_person_id = #{Irm::Person.table_name}.id
                ) d_close)).
        select(%Q(    (SELECT
            COUNT(1)
        FROM
            icm_incident_requests ir2
        WHERE
            ir2.hotline = 'Y' AND
            ir2.support_person_id = #{Irm::Person.table_name}.id
                AND EXISTS( SELECT
                    1
                FROM
                    icm_incident_statuses iss
                WHERE
                    iss.id = ir2.incident_status_id
                        AND iss.close_flag <> 'Y')) c_untreated)).
        select(%Q(    (SELECT
            group_concat(concat(ir2.request_number, '-', uv.name))
        FROM
            icm_incident_requests ir2, icm_urgence_codes_vl uv
        WHERE
            ir2.hotline = 'Y' AND uv.language = 'zh' AND uv.id = ir2.urgence_id AND
            ir2.support_person_id = #{Irm::Person.table_name}.id
                AND EXISTS( SELECT
                    1
                FROM
                    icm_incident_statuses iss
                WHERE
                    iss.id = ir2.incident_status_id
                        AND iss.close_flag <> 'Y')) d_untreated)).
        select(%Q(    (SELECT
            group_concat(concat(ir3.request_number, '-', uv.name))
        FROM
            icm_incident_requests ir3, icm_urgence_codes_vl uv
        where
            ir3.hotline = 'Y' AND uv.language = 'zh' AND uv.id = ir3.urgence_id AND
            EXISTS(SELECT * FROM icm_incident_histories iih WHERE ir3.id = iih.request_id AND
            iih.property_key = 'new_reply' AND
            date_format(iih.created_at, '%Y-%m-%d') <= '#{Date.strptime("#{end_date}", '%Y-%m-%d').strftime("%Y-%m-%d")}' AND
            date_format(iih.created_at, '%Y-%m-%d') >= '#{Date.strptime("#{start_date}", '%Y-%m-%d').strftime("%Y-%m-%d")}'
                AND iih.created_by = #{Irm::Person.table_name}.id)) d_received)).
        select(%Q(    (SELECT
            COUNT(1)
        FROM
            icm_incident_requests ir3
        where
            ir3.hotline = 'Y' AND
            EXISTS(SELECT * FROM icm_incident_histories iih WHERE ir3.id = iih.request_id AND
            iih.property_key = 'new_reply' AND
            date_format(iih.created_at, '%Y-%m-%d') <= '#{Date.strptime("#{end_date}", '%Y-%m-%d').strftime("%Y-%m-%d")}' AND
            date_format(iih.created_at, '%Y-%m-%d') >= '#{Date.strptime("#{start_date}", '%Y-%m-%d').strftime("%Y-%m-%d")}'
                AND iih.created_by = #{Irm::Person.table_name}.id)) c_received))

    #statis = Icm::IncidentRequest.select_all.enabled

    datas = []
    headers = [
        "工号",
        "姓名",
        "选定时间关闭数量",
        "Detail",
        "当前未解决问题",
        "Detail",
        "选定时间内接单数",
        "Detail"
    ]
    member.each do |mm|
      data = Array.new(8)
      data[0] = mm[:login_name]
      data[1] = mm[:full_name]
      data[2] = mm[:c_close]
      data[3] = mm[:d_close]
      data[4] = mm[:c_untreated]
      data[5] = mm[:d_untreated]
      data[6] = mm[:c_received]
      data[7] = mm[:d_received]
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
