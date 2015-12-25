# -*- coding: utf-8 -*-
class Ccc::OuterQuestionProgressExport < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}
    statis = Icm::IncidentRequest.
        select_all.
        enabled.
        with_category(I18n.locale).
        with_priority(I18n.locale).
        with_requested_by(I18n.locale).
        with_incident_status(I18n.locale).
        with_supporter(I18n.locale).
        with_request_type(I18n.locale).
        with_organization(I18n.locale).
        with_incident_status(I18n.locale).
        with_submitted_by.
        order("(#{Icm::IncidentRequest.table_name}.submitted_date) ASC")

    # 根据项目查找
    project_id = params[:project_name]
    unless params[:project_name].present?
      project_id = Irm::ExternalSystemPerson.where("person_id = ?",params[:customer_no]).collect{ |esp| [esp.external_system_id]}
    end
    if project_id.present?
      statis = statis.where(:external_system_id=>project_id)
    end

    # 根据状态查找
    if params[:service_list_status].present?
      statis = statis.where(:incident_status_id=>params[:service_list_status])
    end

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
        "系统类别",
        "客户名称",
        "问题提交人",
        "创建日期",
        "创建时间",
        "最新状态",
        "处理人",
        "参与者1",
        "参与者2",
        "其他参与者"
    ]

    statis.each do |s|
      watcher_ids = Irm::Watcher.where(:watchable_id=>s[:id]).collect { |w|
        Irm::Person.find(w.member_id).full_name
      }
      if watcher_ids.length >3
        for i in 3..watcher_ids.length-1
          watcher_ids[2] = "#{watcher_ids[2]};#{watcher_ids[i]}"
        end
      end
      data = Array.new(14)
      data[0] = s[:request_number]
      data[1] = s[:title]
      data[2] = s[:priority_name]
      data[3] = s[:request_type_name]
      data[4] = s[:incident_category_name]
      data[5] = s[:organization_name]
      data[6] = s[:requested_name]
      data[7] = s[:submitted_date].strftime("%F")
      data[8] = s[:submitted_date].strftime("%T")
      data[9] = s[:incident_status_name]
      data[10] = s[:supporter_name]
      data[11] = watcher_ids[0] if watcher_ids.length >=1
      data[12] = watcher_ids[1] if watcher_ids.length >=2
      data[13] = watcher_ids[2] if watcher_ids.length >=3
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