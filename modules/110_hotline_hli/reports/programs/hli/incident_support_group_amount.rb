class Hli::IncidentSupportGroupAmount < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}


    support_group_elapse = Icm::IncidentJournalElapse.
        joins("JOIN #{Icm::IncidentJournal.table_name} ON #{Icm::IncidentJournal.table_name}.id = #{Icm::IncidentJournalElapse.table_name}.incident_journal_id").
        joins("JOIN #{Icm::IncidentRequest.table_name} ON #{Icm::IncidentRequest.table_name}.id = #{Icm::IncidentJournal.table_name}.incident_request_id ").
        select("#{Icm::IncidentJournal.table_name}.incident_request_id,#{Icm::IncidentJournalElapse.table_name}.support_group_id").
        group("#{Icm::IncidentJournal.table_name}.incident_request_id,#{Icm::IncidentJournalElapse.table_name}.support_group_id")


    # 读取系统中所有事故单服务类别
    support_groups = Icm::SupportGroup.select_all.with_group(I18n.locale)

    # 处理事故单参数
    if(params[:date_from].present?)
      support_group_elapse = support_group_elapse.where("#{Icm::IncidentRequest.table_name}.submitted_date >= ?",params[:date_from])
    end

    if(params[:date_to].present?)
      support_group_elapse = support_group_elapse.where("#{Icm::IncidentRequest.table_name}.submitted_date <= ?",params[:date_to])
    end

    if(params[:external_system_id].present?)
      support_group_elapse = support_group_elapse.where("#{Icm::IncidentRequest.table_name}.external_system_id = ?",params[:external_system_id])
    end

    if(params[:incident_category_id].present?)
      support_group_elapse = support_group_elapse.where("#{Icm::IncidentRequest.table_name}.incident_category_id = ?",params[:incident_category_id])
    end

    if(params[:incident_sub_category_id].present?)
      support_group_elapse = support_group_elapse.where("#{Icm::IncidentRequest.table_name}.incident_sub_category_id = ?",params[:incident_sub_category_id])
    end

    support_group_elapse_sql = support_group_elapse.to_sql

    support_group_incident_amounts = Icm::IncidentJournalElapse.unscoped.from("(#{support_group_elapse_sql}) a").select("a.support_group_id,count(*) amount").group("a.support_group_id")

    support_group_ids = support_group_incident_amounts.collect{|i| i[:support_group_id]}

    support_groups.delete_if{|i| !support_group_ids.include?(i.id)}

    support_group_members = Irm::GroupMember.
                              joins("JOIN #{Icm::SupportGroup.table_name} ON #{Icm::SupportGroup.table_name}.group_id = #{Irm::GroupMember.table_name}.group_id").
                              joins("JOIN #{Irm::Person.table_name} ON #{Irm::Person.table_name}.id = #{Irm::GroupMember.table_name}.person_id").
                              where("#{Irm::Person.table_name}.assignment_availability_flag = ?",Irm::Constant::SYS_YES).
                              where("#{Icm::SupportGroup.table_name}.id IN (?)",support_group_ids).
                              group("#{Icm::SupportGroup.table_name}.id").
                              select("#{Icm::SupportGroup.table_name}.id support_group_id,count(*) member_count")

    support_group_members_sql = support_group_members.to_sql

    support_group_members_hash = {}

    support_group_members.each{|i| support_group_members_hash.merge!(i[:support_group_id]=>i[:member_count])}


    # 对取得的数据进行处理
    datas = []

    headers = [I18n.t(:label_icm_support_group),I18n.t(:label_summary),I18n.t(:label_irm_group_member),I18n.t(:label_average)]


    support_group_incident_amounts.each do |sa|

      support_group = support_groups.detect{|i| i.id.eql?(sa[:support_group_id])}
      if support_group
        data = []
        data << support_group[:name]
        data << sa[:amount]
        if support_group_members_hash[sa[:support_group_id]]&&support_group_members_hash[sa[:support_group_id]]>0
          data << support_group_members_hash[sa[:support_group_id]]
          data << sa[:amount].fdiv(support_group_members_hash[sa[:support_group_id]]).round(1)
        else
          data << 0
          data << sa[:amount]
        end
        datas << data
      end
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