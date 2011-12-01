class IncidentElapseByStatus < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}
    elapse_datas = Icm::IncidentJournalElapse.
        joins("JOIN #{Icm::IncidentJournal.table_name} ON #{Icm::IncidentJournal.table_name}.id = #{Icm::IncidentJournalElapse.table_name}.incident_journal_id").
        joins("JOIN #{Icm::IncidentRequest.table_name} ON #{Icm::IncidentRequest.table_name}.id = #{Icm::IncidentJournal.table_name}.incident_request_id ").
        select("icm_incident_requests.incident_category_id,icm_incident_journal_elapses.incident_status_id,sum(icm_incident_journal_elapses.real_distance) sum_distance").
        group("icm_incident_requests.incident_category_id,icm_incident_journal_elapses.incident_status_id")

    # 读取系统中所有的事故单状态
    statuses = Icm::IncidentStatus.multilingual.enabled.order("display_sequence")

    # 读取系统中所有事故单服务类别
    categories = Icm::IncidentCategory.multilingual.enabled

    # 处理事故单参数
    if(params[:date_from].present?)
      elapse_datas = elapse_datas.where("#{Icm::IncidentRequest.table_name}.submitted_date >= ?",params[:date_from])
    end

    if(params[:date_to].present?)
      elapse_datas = elapse_datas.where("#{Icm::IncidentRequest.table_name}.submitted_date <= ?",params[:date_to])
    end

    if(params[:external_system_id].present?)
      elapse_datas = elapse_datas.where("#{Icm::IncidentRequest.table_name}.external_system_id = ?",params[:external_system_id])
    end

    if(params[:incident_category_id].present?)
      elapse_datas = elapse_datas.where("#{Icm::IncidentRequest.table_name}.incident_category_id = ?",params[:incident_category_id])
    end

    if(params[:incident_sub_category_id].present?)
      elapse_datas = elapse_datas.where("#{Icm::IncidentRequest.table_name}.incident_sub_category_id = ?",params[:incident_sub_category_id])
    end

    # 只对关闭的事故单进行统计
    close_status = statuses.detect{|i| Irm::Constant::SYS_YES.eql?(i.close_flag)}

    elapse_datas = elapse_datas.where("#{Icm::IncidentRequest.table_name}.incident_status_id = ?",close_status.id) if close_status

    # 对取得的数据进行处理
    datas = []

    status_headers = []
    status_headers[0] = I18n.t(:label_icm_incident_request_incident_category)
    statuses.each_with_index do |status,index|
      status_headers[index+1] = status[:name]
    end

    status_headers << I18n.t(:label_summary)

    status_ids =  statuses.collect{|i| i.id}

    elapse_datas.group_by{|i| i[:incident_category_id]}.each do |incident_category_id,group_elapse_datas|
      data = Array.new(status_ids.length+1,0)
      category =  categories.detect{|i| i.id.eql?(incident_category_id)}
      if category
        data[0] = category[:name]
      else
        data[0] = ""
      end

      group_elapse_datas.each do |g_data|
        index = status_ids.index(g_data[:incident_status_id])
        data[index+1] = g_data[:sum_distance].round
      end

      datas << data

    end

    # 计算统计值
    sums = Array.new(statuses.length+2,0)
    datas.each do |data|
      sum = data[1..data.length-1].reduce(:+)
      data[data.length] = sum
      1.upto(sums.length-1).each do |i|
        sums[i] = sums[i]+data[i]
      end
    end

    sums[0] = I18n.t(:label_summary)

    datas << sums

    {:datas=>datas,:status_headers=>status_headers,:params=>params}
  end

  def to_xls(params)
    columns = []

    result = data(params)

    result[:status_headers].each_with_index do |sh,index|
      columns << {:key=>index.to_s.to_sym,:label=>sh}
    end

    excel_data = []
    result[:datas].each_with_index do |data,index|
      excel_data << data.to_cus_hash
    end

    excel_data.to_xls(columns,{})
  end
end