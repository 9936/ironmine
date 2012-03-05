class IncidentRequestMonthSummary < Irm::ReportManager::ReportBase
  def data(params={})
    language = Irm::Person.current.language_code
    params||={}

    statis = Icm::IncidentRequest.
        where("1=1")
    last_statis = Icm::IncidentRequest.
        where("1=1")

    categories_collection = []
    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      statis = statis.where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", params[:external_system_id] + [])
      last_statis = last_statis.where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", params[:external_system_id] + [])

      categories_collection = Icm::IncidentCategorySystem.where("external_system_id IN (?)", params[:external_system_id] + []).collect(&:incident_category_id)
    end

    statis = statis.
        select("incident_category_id, incident_sub_category_id")

    last_statis = last_statis.
        select("incident_category_id, incident_sub_category_id")

    year = Time.now.strftime('%Y')
    month = Time.now.strftime('%m')

    year = params[:year] if params[:year].present?
    month = params[:month] if params[:month].present?
    statis = statis.where("date_format(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m') = ?", Date.strptime("#{year}-#{month}", '%Y-%m').strftime("%Y-%m"))
    last_statis = last_statis.where("date_format(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m') = ?", Date.strptime("#{year}-#{(month.to_i - 1).to_s}", '%Y-%m').strftime("%Y-%m"))

    closed_statis = statis.
        joins(",#{Icm::IncidentStatus.table_name} ista").
        where("ista.close_flag = ?", "Y").
        where("ista.id = #{Icm::IncidentRequest.table_name}.incident_status_id")

    categories = Icm::IncidentCategory.
        select("#{Icm::IncidentCategory.table_name}.id category_id, '' sub_category_id, cat.name category_name, '' sub_category_name").
        joins(",#{Icm::IncidentCategoriesTl.table_name} cat").
        where("cat.incident_category_id = #{Icm::IncidentCategory.table_name}.id").
        where("cat.language = ?", language)

    categories = categories.where("#{Icm::IncidentCategory.table_name}.id IN (?)", categories_collection) if categories_collection.any?

    sub_categories = Icm::IncidentSubCategory.
        select("ic.id category_id, #{Icm::IncidentSubCategory.table_name}.id sub_category_id, ic.name category_name, ist.name sub_category_name").
        joins(",#{Icm::IncidentCategory.view_name} ic").
        joins(",#{Icm::IncidentSubCategoriesTl.table_name} ist").
        where("ic.language = ist.language").
        where("ist.incident_sub_category_id = #{Icm::IncidentSubCategory.table_name}.id").
        where("ist.language = ?", language).
        where("ic.id = #{Icm::IncidentSubCategory.table_name}.incident_category_id")
    sub_categories = sub_categories.where("ic.id IN (?)", categories_collection + []) if categories_collection.any?

    datas = []
    headers = [I18n.t(:label_icm_incident_request_incident_category),
               I18n.t(:label_report_incident_request_last_month_unclose),
               I18n.t(:label_report_incident_request_this_month_submit),
               I18n.t(:label_report_incident_request_this_month_close),
               I18n.t(:label_report_incident_request_this_month_unclose)]

    categories.each do |c|
      data = Array.new(5)
      data[0] = c[:category_name]

      last_statis_cur = last_statis.
          where("incident_category_id = ?", c[:category_id]).
          where("incident_sub_category_id IS NULL OR LENGTH(incident_sub_category_id) = 0")
      last_statis_cur = last_statis_cur.any? ? last_statis_cur.size : 0

      statis_cur = statis.
          where("incident_category_id = ?", c[:category_id]).
          where("incident_sub_category_id IS NULL OR LENGTH(incident_sub_category_id) = 0")
      statis_cur = statis_cur.any? ? statis_cur.size : 0

      closed_statis_cur = closed_statis.
          where("incident_category_id = ?", c[:category_id]).
          where("incident_sub_category_id IS NULL OR LENGTH(incident_sub_category_id) = 0")
      closed_statis_cur = closed_statis_cur.any? ? closed_statis_cur.size : 0

      unclosed_statis_cur = statis_cur - closed_statis_cur

      data[1] = last_statis_cur
      data[2] = statis_cur
      data[3] = closed_statis_cur
      data[4] = unclosed_statis_cur

      datas << data
    end

    sub_categories.each do |sc|
      data = Array.new(5)
      data[0] = "#{sc[:category_name]}-#{sc[:sub_category_name]}"

      last_statis_cur = last_statis.
          where("incident_sub_category_id = ?", sc[:sub_category_id])
      last_statis_cur = last_statis_cur.any? ? last_statis_cur.size : 0

      statis_cur = statis.
          where("incident_sub_category_id = ?", sc[:sub_category_id])
      statis_cur = statis_cur.any? ? statis_cur.size : 0

      closed_statis_cur = closed_statis.
          where("incident_sub_category_id = ?", sc[:sub_category_id])
      closed_statis_cur = closed_statis_cur.any? ? closed_statis_cur.size : 0

      unclosed_statis_cur = statis_cur - closed_statis_cur

      data[1] = last_statis_cur
      data[2] = statis_cur
      data[3] = closed_statis_cur
      data[4] = unclosed_statis_cur

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