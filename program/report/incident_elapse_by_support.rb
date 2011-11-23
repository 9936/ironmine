class IncidentElapseBySupport < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}
    elapse_datas = Icm::IncidentJournalElapse.
        joins("JOIN #{Icm::IncidentJournal.table_name} ON #{Icm::IncidentJournal.table_name}.id = #{Icm::IncidentJournalElapse.table_name}.incident_journal_id").
        joins("JOIN #{Icm::IncidentRequest.table_name} ON #{Icm::IncidentRequest.table_name}.id = #{Icm::IncidentJournal.table_name}.incident_request_id ").
        select("icm_incident_requests.service_code,icm_incident_journal_elapses.support_group_id,sum(icm_incident_journal_elapses.real_distance) sum_distance").
        group("icm_incident_requests.service_code,icm_incident_journal_elapses.support_group_id")

    # 读取系统中所有的事故单状态
    support_groups = Icm::SupportGroup.enabled.with_group(I18n.locale).select_all

    # 读取系统中所有事故单服务类别
    services = Slm::ServiceCatalog.multilingual.enabled

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

    if(params[:service_code].present?)
      elapse_datas = elapse_datas.where("#{Icm::IncidentRequest.table_name}.service_code = ?",params[:service_code])
    end

    # 只对关闭的事故单进行统计
    statuses = Icm::IncidentStatus.multilingual.enabled.order("display_sequence")
    close_status = statuses.detect{|i| Irm::Constant::SYS_YES.eql?(i.close_flag)}

    elapse_datas = elapse_datas.where("#{Icm::IncidentRequest.table_name}.incident_status_id = ?",close_status.id) if close_status

    # 对取得的数据进行处理
    datas = []

    support_group_headers = []
    support_group_headers[0] = I18n.t(:label_icm_incident_request_service_code)
    support_groups.each_with_index do |support_group,index|
      support_group_headers[index+1] = support_group[:name]
    end

    support_group_headers << I18n.t(:label_summary)


    services.each do |service|
      data = Array.new(support_groups.length+1,0)
      data[0] = service[:name]
      support_groups.each_with_index do |support_group,index|
        elapse_data = elapse_datas.detect{|i| support_group.id.eql?(i[:support_group_id])&&service.catalog_code.eql?(i[:service_code])}
        next unless  elapse_data
        data[index+1] = elapse_data[:sum_distance].round
      end
      datas << data
    end

    # 计算统计值
    avg = Array.new(support_groups.length+2,0)
    datas.each do |data|
      sum = data[1..data.length-1].reduce(:+)
      data[data.length] = sum
      1.upto(avg.length-1).each do |i|
        avg[i] = avg[i]+data[i]
      end
    end

    avg[0] = I18n.t(:label_summary)

    datas << avg

    {:datas=>datas,:support_group_headers=>support_group_headers,:params=>params}
  end

  def to_xls(params)
    columns = []

    result = data(params)

    result[:support_group_headers].each_with_index do |sh,index|
      columns << {:key=>index.to_s.to_sym,:label=>sh}
    end

    excel_data = []
    result[:datas].each_with_index do |data,index|
      excel_data << data.to_cus_hash
    end

    excel_data.to_xls(columns,{})
  end
end