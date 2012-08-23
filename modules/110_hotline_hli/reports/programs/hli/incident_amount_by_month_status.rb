class Hli::IncidentAmountByMonthStatus < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}
    close_status = Icm::IncidentStatus.where("close_flag = ?", Irm::Constant::SYS_YES).first
    language = I18n.locale
    new_data= Icm::IncidentRequest.unscoped.select("MONTH(submitted_date)  months  ,count(1) num").enabled.
           where("YEAR(submitted_date)=?",params[:year]).where("submitted_date >= '2011-01-01'").
           group(" MONTH(submitted_date) ")
    close_data= Icm::IncidentRequest.unscoped.
           select("MONTH( #{Icm::IncidentRequest.table_name}.last_response_date)  months  ,count(1)  num").enabled.
           where("YEAR( #{Icm::IncidentRequest.table_name}.last_response_date)=?",params[:year]).where("#{Icm::IncidentRequest.table_name}.submitted_date >= '2011-01-01'").
           where("#{Icm::IncidentRequest.table_name}.incident_status_id = ?", close_status.id).
           group("MONTH( #{Icm::IncidentRequest.table_name}.last_response_date)")
   # 处理事故单参数
     if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
        new_data = new_data.where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", params[:external_system_id] + [])
        close_data = close_data.where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", params[:external_system_id] + [])
     else
       #new_data = new_data.where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", Irm::ExternalSystem.multilingual.order_with_name.with_person(params[:running_person_id]).enabled.collect(&:id) + []) unless Irm::Person.where("login_name = ?",'anonymous').where("id = ?", params[:running_person_id]).any?
       #close_data = close_data.where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", Irm::ExternalSystem.multilingual.order_with_name.with_person(params[:running_person_id]).enabled.collect(&:id) + []) unless Irm::Person.where("login_name = ?",'anonymous').where("id = ?", params[:running_person_id]).any?
      end

      if(params[:is_report].present?)
        new_data = new_data.where("#{Icm::IncidentRequest.table_name}.hotline = ?",params[:is_report])
        close_data = close_data.where("#{Icm::IncidentRequest.table_name}.hotline = ?",params[:is_report])
      end
    open_data=[]
    1.upto(12).each do |i|
        open_data_m= Icm::IncidentRequest.unscoped.select("#{i} months,count(1) num").enabled.
            #where("date_format(icm_incident_requests.submitted_date, '%Y-%m-%d') <= LAST_DAY(CONCAT(?, '-', ?, '-','1'))",params[:year],i).
            where("date_format(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m-%d') < ?", Date.strptime("#{params[:year]}-#{i}-01", '%Y-%m-%d') + 1.month).
            #where("icm_incident_requests.incident_status_id = '#{close_status.id}'").
            where("#{Icm::IncidentRequest.table_name}.hotline = ?", Irm::Constant::SYS_YES).where("#{Icm::IncidentRequest.table_name}.submitted_date >= '2011-01-01'").
            where("#{Icm::IncidentRequest.table_name}.incident_status_id <> '#{close_status.id}' OR date_format(#{Icm::IncidentRequest.table_name}.last_response_date, '%Y-%m-%d') >= ?", Date.strptime("#{params[:year]}-#{i}-01", '%Y-%m-%d') + 1.month)
        # 处理事故单参数
        if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
          open_data_m = open_data_m.where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", params[:external_system_id] + [])
        else
          #open_data_m = open_data_m.where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", Irm::ExternalSystem.multilingual.order_with_name.with_person(params[:running_person_id]).enabled.collect(&:id) + []) unless Irm::Person.where("login_name = ?",'anonymous').where("id = ?", params[:running_person_id]).any?
        end
        if(params[:is_report].present?)
          open_data_m = open_data_m.where("#{Icm::IncidentRequest.table_name}.hotline = ?",params[:is_report])
        end
       open_data<<open_data_m.first     #取出唯一的一行
    end

    datas=Array.new(13,0)   #定义13行
    new_data.each do |d|
       data=Array.new(5,0)  #定义5列 ,首列放行标题，2-4列放数据，5列放合计
       data[1]=d['num'] #将统计值放到第一列
       datas[d['months']-1]=data  #d[0]代表的是月份，即1月的数据放到 datas的第0个元素里
    end
    close_data.each do |d|
       if(datas[d['months']-1]==0)    #如果该月没有记录
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
           if(d.is_a?(Array))
             sum_col=sum_col+d[index]
           end
         end
        datas[12][index]=sum_col
      end

    {:datas=>datas,:headers=>col_headers,:params=>params}
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