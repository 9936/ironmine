# -*- coding: utf-8 -*-
class Ccc::MitsubishiExport < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}
    project = Irm::ExternalSystem.where("external_system_code = ?", "1").first
    statis = Icm::IncidentRequest.
        select_all.
        enabled.
        with_category(I18n.locale).
        with_requested_by(I18n.locale).
        with_incident_status(I18n.locale).
        with_supporter(I18n.locale).
        with_submitted_by.
        where("external_system_id = ?", project.id).
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
                "编号",
                "分类",
                "三菱汽车内部问题编号",
                "报告日期",
                "部门名称",
                "问题联系人",
                "问题类型",
                "问题分类",
                "摘要",
                "预定处理日",
                "实际处理日",
                "实际完成日",
                "所用工时数（单位：人时）",
                "状态",
                "分派给"
               ]

   
    statis.each do |s|
      data = Array.new(15)
      data[0] = s[:request_number]
      data[1] = s[:incident_category_name]
      data[2] = s[:sattribute7]
      data[3] = s[:submitted_date]
      data[4] = s[:sattribute8]
      data[5] = s[:sattribute11]
      data[6] = s[:sattribute9]
      data[7] = s[:sattribute10]
      data[8] = s[:title]
      data[9] = s[:sattribute14]
      data[10] = s[:sattribute12]
      data[11] = s[:sattribute13]
      data[12] = s[:sattribute6]
      data[13] = s[:incident_status_name]
      data[14] = s[:supporter_name]

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
