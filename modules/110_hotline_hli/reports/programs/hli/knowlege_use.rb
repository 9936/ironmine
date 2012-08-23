class Hli::KnowledgeUse < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    # 按月统计知识查看次数
    knowledge_show_amts = Skm::EntryOperateHistory.select("count(*) amount, DATE_FORMAT(`created_at`,'%Y-%m') date").group("DATE_FORMAT(`created_at`,'%Y-%m')").where(:operate_code=>"SKM_SHOW")

    # 按月统计知识应用次数
    knowledge_apply_amts = Skm::EntryOperateHistory.select("count(*) amount, DATE_FORMAT(`created_at`,'%Y-%m') date").group("DATE_FORMAT(`created_at`,'%Y-%m')").where(:operate_code=>"ICM_APPLY")



    # 处理参数
    if(params[:date_from].present?)
      knowledge_show_amts = knowledge_show_amts.where("#{Skm::EntryOperateHistory.table_name}.created_at >= ?",params[:date_from])
      knowledge_apply_amts = knowledge_apply_amts.where("#{Skm::EntryOperateHistory.table_name}.created_at >= ?",params[:date_from])
    end

    if(params[:date_to].present?)
      knowledge_show_amts = knowledge_show_amts.where("#{Skm::EntryOperateHistory.table_name}.created_at <= ?",params[:date_to])
      knowledge_apply_amts = knowledge_apply_amts.where("#{Skm::EntryOperateHistory.table_name}.created_at <= ?",params[:date_to])
    end

    if(params[:channel_id].present?)
      knowledge_show_amts = knowledge_show_amts.join("JOIN #{Skm::EntryHeader.table_name} ON #{Skm::EntryHeader.table_name}.id = #{Skm::EntryOperateHistory.table_name}.entry_id").where("#{Skm::EntryHeader.table_name}.channel_id = ?",params[:channel_id])
      knowledge_apply_amts = knowledge_apply_amts.join("JOIN #{Skm::EntryHeader.table_name} ON #{Skm::EntryHeader.table_name}.id = #{Skm::EntryOperateHistory.table_name}.entry_id").where("#{Skm::EntryHeader.table_name}.channel_id = ?",params[:channel_id])
    end


    datas = []

    group_datas = {}

    chart_datas = {}

    chart_datas[:fields] = ["date","show_amt","apply_amt"]
    chart_datas[:data_fields] = ["show_amt","apply_amt"]
    chart_datas[:series_title] = [I18n.t(:label_report_knowledge_use_show),I18n.t(:label_report_knowledge_use_apply)]


    knowledge_show_amts.each do |ksa|
      if group_datas[ksa[:date]]
        group_datas[ksa[:date]].merge!({:show_amt=>ksa[:amount]})
      else
        group_datas[ksa[:date]] = {:date=>ksa[:date],:show_amt=>ksa[:amount]}
      end
    end

    knowledge_apply_amts.each do |ksa|
      if group_datas[ksa[:date]]
        group_datas[ksa[:date]].merge!({:apply_amt=>ksa[:amount]})
      else
        group_datas[ksa[:date]] = {:date=>ksa[:date],:apply_amt=>ksa[:amount]}
      end
    end

    chart_datas[:origin_data] = group_datas.values

    headers = [I18n.t(:label_report_month),I18n.t(:label_report_knowledge_use_show),I18n.t(:label_report_knowledge_use_apply)]

    group_datas.each do |key,values|
      data = []
      data << key
      if values[:show_amt]
        data << values[:show_amt]
      else
        data << 0
      end

      if values[:apply_amt]
        data << values[:apply_amt]
      else
        data << 0
      end
      datas << data
    end

    {:datas=>datas,:headers=>headers,:params=>params,:chart_datas=>chart_datas}
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