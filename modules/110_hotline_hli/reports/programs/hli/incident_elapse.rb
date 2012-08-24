class Hli::IncidentElapse < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}


    support_group_elapse_datas = Icm::IncidentJournalElapse.
        joins("JOIN #{Icm::IncidentJournal.table_name} ON #{Icm::IncidentJournal.table_name}.id = #{Icm::IncidentJournalElapse.table_name}.incident_journal_id").
        joins("JOIN #{Icm::IncidentRequest.table_name} ON #{Icm::IncidentRequest.table_name}.id = #{Icm::IncidentJournal.table_name}.incident_request_id ").
        select("#{Icm::IncidentJournal.table_name}.incident_request_id,#{Icm::IncidentJournalElapse.table_name}.support_group_id,sum(#{Icm::IncidentJournalElapse.table_name}.real_distance) sum_distance").
        group("#{Icm::IncidentJournal.table_name}.incident_request_id,#{Icm::IncidentJournalElapse.table_name}.support_group_id")

    status_elapse_datas = Icm::IncidentJournalElapse.
        joins("JOIN #{Icm::IncidentJournal.table_name} ON #{Icm::IncidentJournal.table_name}.id = #{Icm::IncidentJournalElapse.table_name}.incident_journal_id").
        joins("JOIN #{Icm::IncidentRequest.table_name} ON #{Icm::IncidentRequest.table_name}.id = #{Icm::IncidentJournal.table_name}.incident_request_id ").
        select("#{Icm::IncidentJournal.table_name}.incident_request_id,#{Icm::IncidentJournalElapse.table_name}.incident_status_id,sum(#{Icm::IncidentJournalElapse.table_name}.real_distance) sum_distance").
        group("#{Icm::IncidentJournal.table_name}.incident_request_id,#{Icm::IncidentJournalElapse.table_name}.incident_status_id")


    incident_requests = Icm::IncidentRequest.list_all

    # 读取系统中所有的事故单状态
    statuses = Icm::IncidentStatus.multilingual.enabled.order("display_sequence")

    # 读取系统中所有事故单服务类别
    support_groups = Icm::SupportGroup.select_all.with_group(I18n.locale)

    show_option = params[:show_option]||"SUPPORT_GROUP"

    # 处理事故单参数
    if(params[:date_from].present?)
      incident_requests = incident_requests.where("#{Icm::IncidentRequest.table_name}.submitted_date >= ?",params[:date_from])
      support_group_elapse_datas = support_group_elapse_datas.where("#{Icm::IncidentRequest.table_name}.submitted_date >= ?",params[:date_from])
      status_elapse_datas = status_elapse_datas.where("#{Icm::IncidentRequest.table_name}.submitted_date >= ?",params[:date_from])
    end

    if(params[:date_to].present?)
      incident_requests = incident_requests.where("#{Icm::IncidentRequest.table_name}.submitted_date <= ?",params[:date_to])
      support_group_elapse_datas = support_group_elapse_datas.where("#{Icm::IncidentRequest.table_name}.submitted_date <= ?",params[:date_to])
      status_elapse_datas = status_elapse_datas.where("#{Icm::IncidentRequest.table_name}.submitted_date <= ?",params[:date_to])
    end

    if(params[:external_system_id].present?)
      incident_requests = incident_requests.where("#{Icm::IncidentRequest.table_name}.external_system_id = ?",params[:external_system_id])
      support_group_elapse_datas = support_group_elapse_datas.where("#{Icm::IncidentRequest.table_name}.external_system_id = ?",params[:external_system_id])
      status_elapse_datas = status_elapse_datas.where("#{Icm::IncidentRequest.table_name}.external_system_id = ?",params[:external_system_id])
    end

    if(params[:incident_category_id].present?)
      incident_requests = incident_requests.where("#{Icm::IncidentRequest.table_name}.incident_category_id = ?",params[:incident_category_id])
      support_group_elapse_datas = support_group_elapse_datas.where("#{Icm::IncidentRequest.table_name}.incident_category_id = ?",params[:incident_category_id])
      status_elapse_datas = status_elapse_datas.where("#{Icm::IncidentRequest.table_name}.incident_category_id = ?",params[:incident_category_id])
    end


    if(params[:incident_sub_category_id].present?)
      incident_requests = incident_requests.where("#{Icm::IncidentRequest.table_name}.incident_sub_category_id = ?",params[:incident_sub_category_id])
      support_group_elapse_datas = support_group_elapse_datas.where("#{Icm::IncidentRequest.table_name}.incident_sub_category_id = ?",params[:incident_sub_category_id])
      status_elapse_datas = status_elapse_datas.where("#{Icm::IncidentRequest.table_name}.incident_sub_category_id = ?",params[:incident_sub_category_id])
    end

    # 只对关闭的事故单进行统计
    close_status = statuses.detect{|i| Irm::Constant::SYS_YES.eql?(i.close_flag)}

    if close_status
      incident_requests = incident_requests.where("#{Icm::IncidentRequest.table_name}.incident_status_id = ?",close_status.id)
      support_group_elapse_datas = support_group_elapse_datas.where("#{Icm::IncidentRequest.table_name}.incident_status_id = ?",close_status.id)
      status_elapse_datas = status_elapse_datas.where("#{Icm::IncidentRequest.table_name}.incident_status_id = ?",close_status.id)
    end

    headers = []
    # 报表中所需要统计的支持组
    if ["ALL","SUPPORT_GROUP"].include?(show_option)
      support_group_elapse_datas_hash = {}
      support_group_ids = []
      support_group_elapse_datas.each{|i|
        if i[:support_group_id].present?
          support_group_ids << i[:support_group_id]
          support_group_elapse_datas_hash["#{i[:incident_request_id]}_#{i[:support_group_id]}"] = i[:sum_distance]
        else
          if support_group_elapse_datas_hash["#{i[:incident_request_id]}"].present?
            support_group_elapse_datas_hash["#{i[:incident_request_id]}"] = support_group_elapse_datas_hash["#{i[:incident_request_id]}"]+i[:sum_distance]
          else
            support_group_elapse_datas_hash["#{i[:incident_request_id]}"] = i[:sum_distance]
          end
        end
      }
      support_group_ids.compact.uniq
      support_groups.delete_if{|i| !support_group_ids.include?(i.id)}

      headers[0] = "Empty Support Group"
      support_groups.each do |support_group|
        headers << support_group[:name]
      end
    end

    # 报表中所需要统计的状态
    if ["ALL","STATUS"].include?(show_option)
      status_elapse_datas_hash = {}
      status_ids = []
      status_elapse_datas.each{|i|
        if i[:incident_status_id].present?
          status_ids << i[:incident_status_id]
          status_elapse_datas_hash["#{i[:incident_request_id]}_#{i[:incident_status_id]}"] = i[:sum_distance]
        end
      }
      status_ids.compact.uniq
      statuses.delete_if{|i| !status_ids.include?(i.id)}

      statuses.each do |status|
        headers << status[:name]
      end
    end

    # 对取得的数据进行处理
    report_datas = []
    incident_requests.each do |request|
      report_data = []
      if ["ALL","SUPPORT_GROUP"].include?(show_option)
        report_data <<  support_group_elapse_datas_hash[request.id]
        support_groups.each do |support_group|
          if support_group_elapse_datas_hash["#{request.id}_#{support_group.id}"]
            report_data << support_group_elapse_datas_hash["#{request.id}_#{support_group.id}"]
          else
            report_data << 0
          end
        end
      end
      if ["ALL","STATUS"].include?(show_option)
        statuses.each do |status|
          if status_elapse_datas_hash["#{request.id}_#{status.id}"]
            report_data << status_elapse_datas_hash["#{request.id}_#{status.id}"]
          else
            report_data << 0
          end
        end
      end

      report_datas << report_data
    end

    {:datas=>incident_requests,:report_datas=>report_datas,:headers=>headers,:params=>params}
  end

  def to_xls(params)
    columns = [{:key=>:request_number,:label=>I18n.t(:label_icm_incident_request_request_number_shot)},
               {:key=>:title,:label=>I18n.t(:label_icm_incident_request_title)},
               {:key=>:requested_organization_name,:label=>I18n.t(:label_icm_incident_request_organization)},
               {:key=>:requested_name,:label=>I18n.t(:label_icm_incident_request_requested_by)},
               {:key=>:external_system_name,:label=>I18n.t(:label_irm_external_system)},
               {:key=>:service_name,:label=>I18n.t(:label_icm_incident_request_service_code)},
               {:key=>:priority_name,:label=>I18n.t(:label_icm_incident_request_priority)}]

    result = data(params)

    result[:headers].each_with_index do |sh,index|
      columns << {:key=>index.to_s.to_sym,:label=>sh}
    end

    excel_data = []
    result[:datas].each_with_index do |data,index|
      excel_data << {:request_number=>data[:request_number],
                     :title=>data[:title],
                     :requested_organization_name=>data[:requested_organization_name],
                     :requested_name=>data[:requested_name],
                     :external_system_name=>data[:external_system_name],
                     :service_name=>data[:service_name],
                     :priority_name=>data[:priority_name]}.merge(result[:report_datas][index].to_cus_hash)
    end

    excel_data.to_xls(columns,{})
  end
end