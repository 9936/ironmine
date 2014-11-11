# -*- coding:utf-8 -*-
class Yan::CuxMonthStat < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    start_date = params[:start_date]
    unless params[:start_date].present?
      start_date = "1970-1-1"
    end

    end_date = params[:end_date]
    unless params[:end_date].present?
      end_date = "2099-1-1"
    end

    datas = []
    headers = [
        'SITE',
        '日期',
        '开票数量',
        '关票数量',
        '系统残留数量'
    ]

    for today in (Date.strptime(start_date, '%Y-%m-%d')).strftime('%Y-%m-%d').to_datetime..(Date.strptime(end_date, '%Y-%m-%d')).strftime('%Y-%m-%d').to_datetime do
      data = Array.new(5)
      system = Irm::ExternalSystem.multilingual.where("#{Irm::ExternalSystem.table_name}.id = ?", params[:external_system_id])
      data[0] = system.first[:system_name]
      data[1] = today.strftime('%Y-%m-%d').to_s
      n = Icm::IncidentRequest.
          where("date_format(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m-%d') = ?",
                today.strftime('%Y-%m-%d')).
          where("#{Icm::IncidentRequest.table_name}.external_system_id = ?", params[:external_system_id])
      n = n.where("#{Icm::IncidentRequest.table_name}.support_group_id = ?", params[:support_group_id]) if params[:support_group_id]
      data[2] = n.size.to_s

      c = Icm::IncidentRequest.
          where("EXISTS(SELECT 1 FROM icm_incident_journals ij WHERE ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND ij.reply_type = 'CLOSE' AND  DATE_FORMAT(ij.created_at, '%Y-%m-%d') = ?)",
                today.strftime('%Y-%m-%d')).
          where("#{Icm::IncidentRequest.table_name}.external_system_id = ?", params[:external_system_id])
      c = c.where("#{Icm::IncidentRequest.table_name}.support_group_id = ?", params[:support_group_id]) if params[:support_group_id]
      data[3] = c.size.to_s

      e = Icm::IncidentRequest.
          where("date_format(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m-%d') <= ?",
                today.strftime('%Y-%m-%d')).
          where("#{Icm::IncidentRequest.table_name}.external_system_id = ?", params[:external_system_id]).
          where("NOT EXISTS(SELECT 1 FROM icm_incident_journals ij WHERE ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND ij.reply_type = 'CLOSE' AND DATE_FORMAT(ij.created_at, '%Y-%m-%d') <= ?)",
                today.strftime('%Y-%m-%d'))
      e = e.where("#{Icm::IncidentRequest.table_name}.support_group_id = ?", params[:support_group_id]) if params[:support_group_id]
      data[4] = e.size.to_s
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
