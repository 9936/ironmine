# -*- coding: utf-8 -*-
class Ccc::UmcExport < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    statis = Icm::IncidentRequest.
        select_all.
        enabled.
        with_category(I18n.locale).
        with_close_reason(I18n.locale).
        with_requested_by(I18n.locale).
        with_incident_status(I18n.locale).
        with_supporter(I18n.locale).
        with_submitted_by.
        with_priority(I18n.locale).
        with_external_system(I18n.locale).
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

    ex_attributes = []
    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      statis = statis.where("external_system.id IN (?)", params[:external_system_id] + [])

      if params[:external_system_id].present? && params[:external_system_id].size == 1
        ex_attributes = Irm::ObjectAttribute.multilingual.enabled.
            where("external_system_id = ?", params[:external_system_id][0]).
            where("field_type = ?", "SYSTEM_CUX_FIELD").order("display_sequence ASC")
      end

    else
      current_acc_systems = Irm::ExternalSystem.multilingual.order_with_name.with_person(params[:running_person_id]).enabled.collect(&:id)
      statis = statis.where("external_system.id IN (?)", current_acc_systems + []) unless Irm::Person.where("login_name = ?",'anonymous').where("id = ?", params[:running_person_id]).any?
      if current_acc_systems.present? && current_acc_systems.size == 1
        ex_attributes = Irm::ObjectAttribute.multilingual.enabled.
            where("external_system_id = ?", params[:external_system_id][0]).
            where("field_type = ?", "SYSTEM_CUX_FIELD").order("display_sequence ASC")
      end
    end

    if params[:status_id].present? && params[:status_id].size > 0 && params[:status_id][0].present?
      statis = statis.where("incident_status_id IN (?)", params[:status_id] + [''])else
    end

    datas = []

    headers = [
                "问题编号",
                "问题提交时间",
                "问题结束时间",
                "优先级",
                "问题状态",
                "问题描述",
                "分派给",
                "项目名称",
                "问题提交人",
                "参与者",
                "最后更新时间",
                "问题分类"
               ]
    ex_attributes.each do |ea|
      headers << ea[:name]
    end
   
    statis.each do |s|
      data = Array.new(12 + ex_attributes.size)
      data[0] = s[:request_number]
      data[1] = s[:submitted_date].strftime("%F %T")
      last_close_journal = Icm::IncidentJournal.
          where("incident_request_id = ?", s.id).
          where("reply_type = ?", "CLOSE").
          select("created_at").
          order("created_at DESC").limit(1)
      if last_close_journal.any?
        data[2] = last_close_journal.first[:created_at].strftime("%F %T")
      else
        data[2] = ""
      end
      data[3] = s[:priority_name]
      data[4] = s[:incident_status_name]
      data[5] = s[:title]
      data[6] = s[:supporter_name]
      data[7] = s[:external_system_name]
      data[8] = s[:submitted_name]
      watchers = s.person_watchers
      if !watchers.nil? && watchers.any?
        data[9] = watchers.collect(&:full_name).join(',')
      else
        data[9] = ""
      end
      data[10] = s[:last_response_date].strftime("%F %T")
      data[11] = s[:incident_category_name]
      nc = 12
      ex_attributes.each do |ea|
        data[nc] = s[ea[:attribute_name].to_sym]
        nc = nc + 1
      end
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
