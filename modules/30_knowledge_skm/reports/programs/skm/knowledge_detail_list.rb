class Skm::KnowledgeDetailList < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    accessable_channel_ids = Skm::Channel.
        where("1=1").
        with_group_ids(Irm::Person.find(params[:running_person_id]).groups.collect(&:id)).collect(&:id)

    status = Skm::EntryHeader.
        select(%Q(#{Skm::EntryHeader.table_name}.doc_number, #{Skm::EntryHeader.table_name}.entry_title, #{Skm::EntryHeader.table_name}.keyword_tags,
                  #{Skm::EntryHeader.table_name}.version_number, sch.name,
                  lv.meaning, ip.full_name, ip.login_name, #{Skm::EntryHeader.table_name}.published_date, #{Skm::EntryHeader.table_name}.updated_at )).
        where("1=1").
        joins(", #{Irm::LookupValue.view_name} lv").
        joins(", #{Skm::Channel.view_name} sch").
        joins(", #{Irm::Person.table_name} ip").
        where("ip.id = #{Skm::EntryHeader.table_name}.author_id").
        where(%Q(#{Skm::EntryHeader.table_name}.version_number = (SELECT MAX(sht.version_number)
                                      FROM #{Skm::EntryHeader.table_name} sht
                                      WHERE sht.doc_number = #{Skm::EntryHeader.table_name}.doc_number) )).
        where("#{Skm::EntryHeader.table_name}.entry_status_code = lv.lookup_code").
        where("#{Skm::EntryHeader.table_name}.channel_id = sch.id").
        where("lv.language = 'zh'").
        where("sch.language = 'zh'").
        where("sch.id IN (?)", accessable_channel_ids + []).
        order("#{Skm::EntryHeader.table_name}.doc_number + 0 ASC")

    if params[:start_date].present?
      statis = statis.where("date_format(#{Skm::EntryHeader.table_name}.published_date, '%Y-%m-%d') >= ?",
                            Date.strptime("#{params[:start_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
    end


    if params[:end_date].present?
      statis = statis.where("date_format(#{Skm::EntryHeader.table_name}.published_date, '%Y-%m-%d') <= ?",
                            Date.strptime("#{params[:end_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
    end

    datas = []
    headers = [I18n.t(:label_skm_entry_header_doc_number),
               I18n.t(:label_skm_entry_header_title),
               I18n.t(:label_skm_entry_header_keyword_tags),
               I18n.t(:label_skm_entry_header_version),
               I18n.t(:label_skm_channel),
               I18n.t(:label_skm_entry_header_status_code),
               I18n.t(:label_skm_entry_header_author_name),
               I18n.t(:label_irm_person_work_number),
               I18n.t(:label_skm_entry_header_published_date),
               I18n.t(:label_skm_file_data_updated_at)]

    status.each do |e|
      data = Array.new(9)
      data[0] = e[:doc_number]
      data[1] = e[:entry_title]
      data[2] = e[:keyword_tags]
      data[3] = e[:version_number]
      data[4] = e[:name]
      data[5] = e[:meaning]
      data[6] = e[:full_name]
      data[7] = e[:login_name]
      data[8] = e[:published_date]
      data[9] = e[:updated_at]

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