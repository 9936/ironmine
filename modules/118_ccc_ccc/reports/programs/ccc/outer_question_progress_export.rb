# -*- coding: utf-8 -*-
class Ccc::OuterQuestionProgressExport < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}
    # project = Irm::ExternalSystem.where("external_system_code = ?", "1").first
    statis = Icm::IncidentRequest.
        select_all.
        enabled.
        with_category(I18n.locale).
        with_requested_by(I18n.locale).
        with_incident_status(I18n.locale).
        with_supporter(I18n.locale).
        with_submitted_by.
        # where("external_system_id = ?", project.id).
        order("(#{Icm::IncidentRequest.table_name}.submitted_date) ASC")
    end_date = params[:end_date]
    unless params[:end_date].present?
      end_date = "2099-1-1"
    end
    if params[:end_date].present?
      statis = statis.where("date_format(icm_incident_requests.submitted_date, '%Y-%m-%d') <= ?", Date.strptime("#{end_date}", '%Y-%m-%d').strftime("%Y-%m-%d"))
    end

    start_date = params[:start_date]
    unless params[:start_date].present?
      start_date = "1970-1-1"
    end
    statis = statis.where("date_format(icm_incident_requests.submitted_date, '%Y-%m-%d') >= ?", Date.strptime("#{start_date}", '%Y-%m-%d').strftime("%Y-%m-%d"))

    datas = []

    headers = [
        "问题编号",
        "问题描述",
        "优先级",
        "问题类型",
        "问题提交人",
        "创建日期",
        "处理人"
    ]

    statis.each do |s|
      data = Array.new(7)
      data[0] = s[:request_number]
      data[1] = s[:title]
      data[2] = s[:priority_name]
      data[3] = s[:request_type_name]
      data[4] = s[:requested_name]
      data[5] = s[:submitted_date].strftime("%F %T")
      data[6] = s[:supporter_name]
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