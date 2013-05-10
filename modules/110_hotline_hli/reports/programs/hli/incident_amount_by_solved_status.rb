# -*- coding:utf-8 -*-
class Hli::IncidentAmountBySolvedStatus < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}
    close_status = Icm::IncidentStatus.where("close_flag = ?", Irm::Constant::SYS_YES).first
    language = I18n.locale

    category_codes = ["HOTLINE_ZIXUN", "HOTLINE_XUQIU", "HOTLINE_WENTI", "HOTLINE_XIEZHU"]

    system_ids = []

    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      system_ids << params[:external_system_id]
    else
      current_acc_systems = Irm::ExternalSystem.multilingual.order_with_name.with_person(params[:running_person_id]).enabled.collect(&:id)
      system_ids = system_ids + current_acc_systems
    end

    main_data = Icm::IncidentRequest.unscoped.enabled.where("external_system_id IN (?)", system_ids).where("hotline = ?", "Y")
    #本月接单数
    this_month_new = main_data.
        select("count(1) this_month_new").
        where("date_format(submitted_date, '%Y-%m') = ?", Date.strptime("#{params[:start][:year]}-#{params[:start][:month]}", '%Y-%m'))
    #本月解决数
    this_month_resolved = main_data.
        select("count(1) this_month_resolved").
        where("EXISTS (SELECT * FROM icm_incident_journals ij WHERE ij.incident_request_id = icm_incident_requests.id AND ij.reply_type = ? AND date_format(ij.created_at, '%Y-%m') = ?)",
              "CLOSE", Date.strptime("#{params[:start][:year]}-#{params[:start][:month]}", '%Y-%m'))
    #上月未解决数
    pre_month_unsolved = main_data.
        select("count(1) pre_month_unsolved").
        where("NOT EXISTS (SELECT * FROM icm_incident_journals ij WHERE ij.incident_request_id = icm_incident_requests.id AND ij.reply_type = ? AND date_format(ij.created_at, '%Y-%m') < ?)",
              "CLOSE", Date.strptime("#{params[:start][:year]}-#{params[:start][:month]}", '%Y-%m'))

    datas = []
    headers = [
               "业务分类",
               "上月未解决数",
               "本月接单数",
               "本月解决数",
               "未解决数"
               ]

    categories = Icm::IncidentCategory.
        select("ict.name category_name, ict.incident_category_id category_id").
        joins(",#{Icm::IncidentCategoriesTl.table_name} ict").
        where("ict.language = ?", language).
        where("ict.incident_category_id = #{Icm::IncidentCategory.table_name}.id").
        where("code IN (?)", category_codes).
        order("display_sequence ASC")

    categories.each do |c|
      data = Array.new(5)
      data[0] = c[:category_name]
      p_pre_month_unsolved = pre_month_unsolved.where("incident_category_id = ?", c[:category_id])
      data[1] = p_pre_month_unsolved.first[:pre_month_unsolved]
      p_this_month_new = this_month_new.where("incident_category_id = ?", c[:category_id])
      data[2] = p_this_month_new.first[:this_month_new]
      p_this_month_resolved = this_month_resolved.where("incident_category_id = ?", c[:category_id])
      data[3] = p_this_month_resolved.first[:this_month_resolved]
      data[4] = (data[1].to_i - data[3].to_i).to_s

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