# -*- coding: utf-8 -*-
class Hli::SupporterWorkloadDetails < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    statis = Icm::IncidentWorkload.
        joins(" LEFT OUTER JOIN #{Irm::LookupValue.view_name} lv ON lv.language = 'zh' AND lv.lookup_type = 'WORKLOAD_TYPE' AND lv.lookup_code = #{Icm::IncidentWorkload.table_name}.workload_type").
        joins(",#{Icm::IncidentRequest.table_name} ir").
        joins(",#{Irm::Person.table_name} p").
        joins(",#{Icm::IncidentStatus.view_name} ins").
        where("#{Icm::IncidentWorkload.table_name}.incident_request_id = ir.id").
        where("#{Icm::IncidentWorkload.table_name}.person_id = p.id").
        where("ir.incident_status_id = ins.id").
        where("ins.language = 'zh'").
        select("#{Icm::IncidentWorkload.table_name}.real_processing_time, #{Icm::IncidentWorkload.table_name}.workload_type").
        select("p.full_name, p.login_name").
        select("ir.title, ir.summary, ir.submitted_date, ir.last_response_date, ir.request_number").
        select("ins.name incident_status_name").
        select("lv.meaning 'workload_type_name'")

    if params[:start_date].present? && params[:end_date].present?
      statis = statis.where("date_format(ir.last_response_date, '%Y-%m-%d') >= ?", Date.strptime("#{params[:start_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
      statis = statis.where("date_format(ir.last_response_date, '%Y-%m-%d') <= ?", Date.strptime("#{params[:end_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
    end

    if params[:hotline].present?
      statis = statis.where("icm_incident_requests.hotline = ?", "Y")
    end

    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      statis = statis.where("ir.external_system_id IN (?)", params[:external_system_id] + [])
    else
      statis = statis.where("ir.external_system_id IN (?)", Irm::ExternalSystem.multilingual.order_with_name.with_person(params[:running_person_id]).enabled.collect(&:id) + []) unless Irm::Person.where("login_name = ?",'anonymous').where("id = ?", params[:running_person_id]).any?
    end

    datas = []
    headers = ["顾问工号",
               "名字",
               "单号",
               "花费工时",
               "工时类型",
               "报告日期",
               "最后更新日期",
               "主题",
               "信息",
               "状态"]

    headers << I18n.t(:label_report_incident_request_journal) if params[:inc_history].present? && params[:inc_history].eql?(Irm::Constant::SYS_YES)

    statis.each do |s|
      data = Array.new(10)
      data[0] = s[:login_name]
      data[1] = s[:full_name]
      data[2] = s[:request_number]
      data[3] = s[:real_processing_time]
      data[4] = s[:workload_type_name]
      data[5] = s[:submitted_date].strftime('%F %T')
      data[6] = s[:last_response_date].strftime('%F %T')
      data[7] = s[:title]
      data[8] = s[:summary]
      data[9] = s[:incident_status_name]
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