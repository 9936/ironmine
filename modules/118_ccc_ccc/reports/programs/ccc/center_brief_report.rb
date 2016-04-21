# -*- coding: utf-8 -*-
class Ccc::CenterBriefReport < Irm::ReportManager::ReportBase
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
        with_type_code(I18n.locale).
        with_submitted_by.
        order("(#{Icm::IncidentRequest.table_name}.submitted_date) ASC")

    all_external_system_ids = []
    # 公司编号条件
    no_external_system_ids = [] #根据公司编号获取的所有项目id
    if params[:start_no].present? && !params[:end_no].present?
      no_external_system_ids = Irm::ExternalSystem.where("organization_no >= ?",params[:start_no]).collect{ |es| es.id}
    end
    if params[:end_no].present? && !params[:start_no].present?
      no_external_system_ids = Irm::ExternalSystem.where("organization_no <= ?",params[:end_no]).collect{ |es| es.id}
    end
    if params[:end_no].present? && params[:start_no].present?
      no_external_system_ids = Irm::ExternalSystem.where("organization_no <= ? AND organization_no >= ?",params[:end_no],params[:start_no]).collect{ |es| es.id}
    end

    # 公司名称条件
    name_external_system_ids = [] #根据公司名称获取的所有项目的id
    if params[:customer_name].present?
      organization_nos = Irm::Organization.multilingual.where("name like ?","%#{params[:customer_name]}%").collect{ |iot| iot.organization_no}
      Irm::ExternalSystem.where(:organization_no=>organization_nos).each do |es|
        name_external_system_ids << es.id
      end
    end

    # 项目条件
    external_system_id = []
    if params[:project_name].present?
      external_system_id << params[:project_name]
    end
    # 一个条件
    if (params[:end_no].present? || params[:start_no].present?) && !params[:customer_name].present? && !params[:project_name].present?
      all_external_system_ids = no_external_system_ids
    elsif !(params[:end_no].present? || params[:start_no].present?) && params[:customer_name].present? && !params[:project_name].present?
      all_external_system_ids = name_external_system_ids
    elsif !(params[:end_no].present? || params[:start_no].present?) && !params[:customer_name].present? && params[:project_name].present?
      all_external_system_ids = external_system_id
      # 两个条件
    elsif (params[:end_no].present? || params[:start_no].present?) && params[:customer_name].present? && !params[:project_name].present?
      all_external_system_ids = no_external_system_ids & name_external_system_ids
    elsif (params[:end_no].present? || params[:start_no].present?) && !params[:customer_name].present? && params[:project_name].present?
      all_external_system_ids = no_external_system_ids & external_system_id
    elsif !(params[:end_no].present? || params[:start_no].present?) && params[:customer_name].present? && params[:project_name].present?
      all_external_system_ids = name_external_system_ids & external_system_id
      # 三个条件
    elsif (params[:end_no].present? || params[:start_no].present?) && params[:customer_name].present? && params[:project_name].present?
      all_external_system_ids = name_external_system_ids & external_system_id & no_external_system_ids
    end

    if params[:end_no].present? || params[:start_no].present? || params[:customer_name].present? || params[:project_name].present?
      statis = statis.where(:external_system_id=>all_external_system_ids)
    end

    # 时间条件
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

    # 状态条件
    if params[:service_list_status].present?
      if params[:service_list_status].eql?"no_close"
        statis = statis.where("incident_status_id != ? ",'000K000922scMSu1QUxWoy')
      else
        statis = statis.where(:incident_status_id=>params[:service_list_status])
      end
    end

    # 支持者条件
    if params[:solver].present?
      statis = statis.where("supporter.full_name like ?","%#{params[:solver]}%")
    end
    # 问题级别条件
    if params[:question_level].present?
      group_ids = []
      support_group_ids = []
      # 如果选择的级别是最高的
      if Irm::Group.find(params[:question_level]).parent_group_id.eql?("")
        Irm::Group.where("id <> ?",'').each do |g|
          group_ids << g.id
        end
      else #第二级别的时候
        group_ids << params[:question_level]
        Irm::Group.where(:parent_group_id=>params[:question_level]).each do |cg|
          group_ids << cg.id
        end
      end

      Icm::SupportGroup.where(:group_id=>group_ids).each do |isg|
        support_group_ids << isg.id
      end

      statis = statis.where(:support_group_id=>support_group_ids)
    end
    # 模块条件
    if params[:module_name].present?
      group_ids = []
      support_group_ids = []
      Irm::Group.multilingual.where("description = ?",params[:module_name]).each do |cg|
        group_ids << cg.id
      end
      Icm::SupportGroup.where(:group_id=>group_ids).each do |isg|
        support_group_ids << isg.id
      end

      statis = statis.where(:support_group_id=>support_group_ids)
    end
    # 组别条件
    if params[:team_id].present?
      support_group_ids = []
      Icm::SupportGroup.where(:group_id=>params[:team_id]).each do |isg|
        support_group_ids << isg.id
      end
      statis = statis.where(:support_group_id=>support_group_ids)
    end

    # 参与者组别条件
    if params[:joiner_team_id].present?
      incident_ids = []
      Irm::GroupMember.where(:group_id=>params[:joiner_team_id]).collect{|i|
        incident_ids += Irm::Watcher.where(:watchable_type=>"Icm::IncidentRequest",:member_type=>"Irm::Person",:member_id=>i.person_id).collect{|j| j.watchable_id}
      }
      incident_ids.uniq!
      statis = statis.where(:id=>incident_ids)
    end

    # 自己处理的事故单
    if params[:my_only].present?
      statis = statis.mine_filter
    end
    # 只选择sla超时的事故单
    if params[:SLA_time_out].present?
      time_out_ids = []
      Ccc::SlaConIncident.all.each do |sci|
        time_out_ids << sci.incident_request_id
      end
      statis = statis.where(:id=>time_out_ids)
    end

    datas = []

    headers = [
        I18n.t(:label_icm_incident_request_request_number_shot),
        I18n.t(:label_icm_incident_request_title),
        I18n.t(:label_icm_incident_request_support_person),
        I18n.t(:label_icm_incident_request_priority),
        I18n.t(:label_icm_incident_request_request_type_code),
        I18n.t(:label_icm_incident_request_incident_category),
        I18n.t(:label_icm_incident_request_incident_sub_category),
        I18n.t(:label_icm_incident_request_requested_by_org),
        I18n.t(:label_icm_incident_request_requested_by),
        I18n.t(:label_icm_incident_request_contact),
        I18n.t(:label_icm_incident_request_submitted_time),
        I18n.t(:label_icm_incident_request_submitted_date),
        I18n.t(:label_icm_incident_request_incident_status_code),
        I18n.t(:label_icm_incident_request_watcher_first),
        I18n.t(:label_icm_incident_request_watcher_second),
        I18n.t(:label_icm_incident_request_watcher_other),
        I18n.t(:label_icm_incident_request_ABAP_relation),
        I18n.t(:label_icm_incident_request_Basis_relation),
        I18n.t(:label_icm_incident_request_first_commit_time),
        I18n.t(:label_icm_incident_request_respond_time),
        I18n.t(:label_icm_incident_request_start_solve_time),
        I18n.t(:label_icm_incident_request_last_date),
        I18n.t(:label_icm_incident_request_total_solve_time),
        I18n.t(:label_icm_incident_request_customer_satisfy),
        I18n.t(:label_icm_incident_request_out_time_flag),
        I18n.t(:label_icm_incident_request_out_time_type),
        I18n.t(:label_icm_incident_request_upgrade_flag)
    ]

    abap_group_member_ids = Irm::GroupMember.select("person_id").where("group_id in ('0014000B2jRU7FjuWOlDfc','0014000B2kYFzYtQ0olbcW','0014000B2kYFzYtQ2OCJou')").group("person_id").collect { |am| am.person_id }
    abap_group_member_ids.uniq!
    basis_group_member_ids = Irm::GroupMember.select("person_id").where("group_id in ('0014000B2jnSnXNsXpilG4','0014000B2kYFzYtQ14JIJ6','0014000B2kYFzYtQ2b4Qcq')").group("person_id").collect { |bm| bm.person_id }
    basis_group_member_ids.uniq!

    statis.each do |s|
      has_abap_flag = false
      has_basis_flag = false
      watcher_ids = []
      Irm::Watcher.where(:watchable_id=>s[:id]).collect { |w|
        person = Irm::Person.find(w.member_id)
        # 排除角色为hotline、客户
        if person.present?
          if !person.role_id.eql?("002N000B2jQQBCsvKW8BfM") && person.profile.user_license.eql?("SUPPORTER")
            watcher_ids << person.full_name
            # 如果观察者中有abap组中的人,则标记为true
            if abap_group_member_ids.include?(person.id)
              has_abap_flag = true
            end
            # 如果观察者中有basis组中的人,则标记为true
            if basis_group_member_ids.include?(person.id)
              has_basis_flag = true
            end
          end
        end
      }
      if watcher_ids.length >3
        for i in 3..watcher_ids.length-1
          watcher_ids[2] = "#{watcher_ids[2]};#{watcher_ids[i]}"
        end
      end

      # 参与者条件
      if params[:joiner].present?
        #如果不存在该参与者,则不往下面执行
        if !watcher_ids.to_s.index(params[:joiner])
          next
        end
      end

      data = Array.new(28)
      data[0] = s[:request_number]
      data[1] = s[:title]
      data[2] = s[:supporter_name]
      data[3] = s[:priority_name]
      data[4] = s[:request_type_code_label]
      data[5] = s[:incident_category_name]
      data[6] = s[:incident_sub_category_name]
      data[7] = s[:organization_name]
      data[8] = s[:requested_name]
      data[9] = s[:attribute1]
      data[10] = s[:submitted_date].strftime("%F")
      data[11] = s[:submitted_date].strftime("%T")
      data[12] = s[:incident_status_name]
      data[13] = watcher_ids[0] if watcher_ids.length >=1
      data[14] = watcher_ids[1] if watcher_ids.length >=2
      data[15] = watcher_ids[2] if watcher_ids.length >=3
      data[16] = has_abap_flag ? "是":""
      data[17] = has_basis_flag ? "是":""
      first_commit_history_time = Icm::IncidentHistory.
          where(:request_id=>s[:id],:property_key=>"incident_status_id",:new_value=>"000K000A0g9LO0pOKPsZ1s").
          order("created_at asc").
          first()
      last_commit_history_time = Icm::IncidentHistory.
          where(:request_id=>s[:id],:property_key=>"incident_status_id",:new_value=>"000K000A0g9LO0pOKPsZ1s").
          order("created_at desc").
          first()
      first_assign_history_time = Icm::IncidentHistory.
          where(:request_id=>s[:id],:property_key=>"incident_status_id",:new_value=>"000K000922scMSu1Q8vthI").
          order("created_at asc").
          first()
      first_solve_history_time = Icm::IncidentHistory.
          where(:request_id=>s[:id],:property_key=>"incident_status_id",:new_value=>"000K000C2hrdz1TO8kREaO").
          order("created_at asc").
          first()

      if first_commit_history_time.present?
        data[18] = first_commit_history_time.created_at.strftime("%F %T")  #首提方案日期
      end
      if first_assign_history_time.present?
        data[19] = first_assign_history_time.created_at.strftime("%F %T")  #第一次分配的时间
      end
      if first_solve_history_time.present?
        data[20] = first_solve_history_time.created_at.strftime("%F %T")  #开始处理时间
      end
      data[21] = s[:updated_at].strftime("%F %T")
      if last_commit_history_time.present? && first_solve_history_time.present?
        #总处理时间 = 最后一次提交方案的时间 - 开始处理的时间
        calendar = Slm::Calendar.where(:external_system_id=>s[:external_system_id]).first()
        end_time = last_commit_history_time.created_at
        start_time = first_solve_history_time.created_at
        time_zone = "Beijing"
        data[22] = calendar.working_time_with_zone(time_zone,start_time,end_time)
        data[22] = (data[22] / 1440.0).round(2)
      end
      # 用户满意度调查
      sroc = Ccc::SatisRateOfConsultant.where(:incident_request_id=>s[:id]).first()
      if sroc.present?
        type_name = ""
        if sroc.grade_type.eql?("VERY")
          type_name = "非常满意"
        elsif sroc.grade_type.eql?("GOOD")
          type_name = "满意"
        else
          type_name = "不满意"
        end
        data[23] = type_name  #客户满意度
      end

      sla_con_incident_scope = Ccc::SlaConIncident.
          joins("LEFT OUTER JOIN slm_sla_instances ssi ON ssi.id = ccc_sla_con_incidents.sla_instance_id").
          where(:incident_request_id=>s[:id]).
          where("ssi.current_status = 'START'")

      if sla_con_incident_scope.length == 0
        data[24] = "正常"
      elsif sla_con_incident_scope.length == 1
        data[24] = sla_con_incident_scope.first().type_name    #警告
        # data[20] = sla_con_incident_scope.first().service_name #超时阶段
        data[25] = service_name(sla_con_incident_scope.first().service_name,s[:type_name]) #超时阶段
      elsif sla_con_incident_scope.length == 2
        sla_con_incident_scope.each do |scis|
          if scis.type_name.eql?("超时")
            data[24] = scis.type_name    #超时
            # data[20] = scis.service_name #超时阶段
            data[25] = service_name(scis.service_name,s[:type_name]) #超时阶段
          end
        end
      end
      upgrade_flag = Icm::IncidentHistory.where("request_id =? and property_key like '%upgrade%' ",s[:id]).size
      data[26] = upgrade_flag == 0 ? "":"升级"
      data[27] = s[:id]
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

  private
  def service_name(service_name,type_name)
    new_service_name = ""
    if service_name.index("新建").present?
      new_service_name = "分配超时"
    elsif service_name.index("分配").present? && service_name.index("处理中").present?
      new_service_name = "开始处理超时"
    elsif service_name.index("处理中").present? && !service_name.index("分配").present?
      new_service_name = "进度更新超时"
    elsif service_name.index("总").present?
      new_service_name = "总处理时间超时"
    end
    if service_name.eql?("总处理时间超时") && type_name.eql?("新增需求")
      new_service_name = ""
    end
    new_service_name
  end
end