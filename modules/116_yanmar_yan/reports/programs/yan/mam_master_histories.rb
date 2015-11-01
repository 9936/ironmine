class Yan::MamMasterHistories < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    statis = Mam::MasterStatus.master_history.order("mam_master_statuses.master_number")
    number = statis.first.master_number
    start_time = statis.first.created_at

    if params[:start_date].present? && params[:end_date].present?
      statis = statis.where("date_format(mm.created_at, '%Y-%m-%d') >= ?", Date.strptime("#{params[:start_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
      statis = statis.where("date_format(mm.created_at, '%Y-%m-%d') <= ?", Date.strptime("#{params[:end_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
    end

    statis.each do |i|
      if i.master_number != number
        number = i.master_number
        start_time = i.created_at
      end
      if i.master_status.eql?("MAM_CLOSE")
        i.urs_end_date = i.mm_updated_at
      end
      i.urs_status = ((i.created_at - start_time)/60).round(2)
      start_time = i.created_at
      i.ticket_created = i.ticket_created.to_s
    end

    datas = []
    headers = [I18n.t(:label_master_number),
               I18n.t(:label_master_created_at),
               I18n.t(:label_last_response),
               I18n.t(:label_close),
               I18n.t(:label_master_status),
               I18n.t(:label_submit),
               I18n.t(:label_support_group),
               I18n.t(:label_support_person),
               I18n.t(:label_process_time)
    ]
    array_size = 9
    statis.each do |s|
      data = Array.new(array_size)
      data[0] = s[:master_number]
      data[1] = s[:ticket_created]
      data[2] = s[:last_response]
      data[3] = s[:urs_end_date]
      data[4] = s[:master_status]
      data[5] = s[:submit]
      data[6] = s[:supportg]
      data[7] = s[:supportp]
      data[8] = s[:urs_status]

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