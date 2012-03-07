class IncidentAmountMonthByStatus < Irm::ReportManager::ReportBase
  #重载data方法，用于取数
  def data(params={})
    params||={}
    new_data= Icm::IncidentRequest.select("MONTH(submitted_date)  months  ,count(1) num").
        where("YEAR(submitted_date)=?",params[:year]).
        group(" MONTH(submitted_date) ")
    close_data= Icm::IncidentRequest.joins("JOIN icm_incident_journals ON icm_incident_requests.id=icm_incident_journals.incident_request_id ").
        select("MONTH( icm_incident_journals.created_at)  months  ,count(1)  num").
        where("YEAR(submitted_date)=?",params[:year]).
        where("icm_incident_journals.reply_type='CLOSE'").
        group("MONTH( icm_incident_journals.created_at)")
    #处理事故单参数
    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      new_data = new_data.where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", params[:external_system_id] + [])
      close_data = close_data.where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", params[:external_system_id] + [])
    end
    open_data=[]
    1.upto(12).each do |i|
      open_data_m= Icm::IncidentRequest.select("#{i} months,count(1) num").
          where("icm_incident_requests.submitted_date<=LAST_DAY(CONCAT(?, '-', ?, '-','2'))",params[:year],i).
          where("NOT EXISTS ( SELECT 1 FROM icm_incident_journals WHERE icm_incident_journals.incident_request_id = icm_incident_requests.id AND icm_incident_journals.reply_type = 'CLOSE' AND icm_incident_journals.created_at < LAST_DAY( CONCAT(?, '-', ?, '-', '2')))",params[:year],i)
      if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
        open_data_m = open_data_m.where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", params[:external_system_id] + [])
      end
      open_data<<open_data_m.first
    end
    datas=Array.new(13,0)
    new_data.each do |d|
      data=Array.new(5,0)
      data[1]=d['num']
      datas[d['months']-1]=data
    end
    close_data.each do |d|
      if datas[d['months']-1]==0    #如果该月没有记录
        data=Array.new(5,0)
        data[2]=d['num'] #将统计值放到第二列
        datas[d['months']-1]=data  #d[0]代表的是月份，即1月的数据放到 datas的第0个元素里
      else
        datas[d['months']-1][2]=d['num']
      end
    end
    open_data.each do |d|
      if(datas[d['months']-1]==0)    #如果该月没有记录
        data=Array.new(5,0)
        data[3]=d['num'] #将统计值放到第三列
        datas[d['months']-1]=data  #d[0]代表的是月份，即1月的数据放到 datas的第0个元素里
      else
        datas[d['months']-1][3]=d['num']
      end
    end
    #初始化行标题
    month_headers= I18n.t(:label_report_icm_incident_months).split(",")
    datas[12]= Array.new(5,0)#初始化合计行
    datas.each_with_index do |d,index|
      d[0]=month_headers[index]
    end
    #初始化列标题
    col_headers= I18n.t(:label_report_icm_incident_status_col_header).split(",")
    #计算每行合计
    datas.each do |data|
      sum_row = data[1..data.length-2].reduce(:+) #不计算行标题和行合计，只加上中间的值
      data[data.length-1]=sum_row
    end
    #计算每列合计
    1.upto(col_headers.length-1) do |index|
      sum_col=0
      datas.each do |d|
        if d.is_a?(Array)
          sum_col=sum_col+d[index]
        end
      end
      datas[12][index]=sum_col
    end
    {:datas=>datas,:headers=>col_headers,:params=>params}
  end

  #重载to_xls方法，用于将报表导出excel文件
  def to_xls(params)
    columns = []
    result = data(params)
    result[:headers].each_with_index do |sh,index|
      columns << {:key=>index.to_s.to_sym,:label=>sh}
    end
    excel_data = []
    result[:datas].each_with_index do |data|
      excel_data << data.to_cus_hash
    end
    excel_data.to_xls(columns,{})
  end
end