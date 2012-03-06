class IncidentAmountMonthByStatus < Irm::ReportManager::ReportBase
  def datas(params={})
    params||={}
    #获取不同状态的数据
    #新增的数据
    data_new = Icm::IncidentRequest.select("MONTH(submitted_date)  month  ,count(1) num").
        group("MONTH(submitted_date) ")

    #关闭状态的数据
    data_close = Icm::IncidentRequest.joins("JOIN #{Icm::IncidentJournal.table_name} ON #{Icm::IncidentRequest.table_name}.id=#{Icm::IncidentJournal.table_name}.incident_request_id ").
               select("MONTH( #{Icm::IncidentJournal.table_name}.created_at)  month  ,count(1)  num").
               where(" #{Icm::IncidentJournal.table_name}.reply_type='CLOSE'").
               group("MONTH( #{Icm::IncidentJournal.table_name}.created_at)")

    if params[:year].present?
      data_new = data_new.where("YEAR(submitted_date)=?", params[:year])
      data_close = data_close.where("YEAR(submitted_date)=?", params[:year])
    end

    if params[:external_system_id].present?
      data_new = data_new.where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", params[:external_system_id] + [])
      data_close = data_close.where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", params[:external_system_id] + [])
    end



    #1到12循环,如果当前月份不存在，则设置0
    data = {}
    1.upto(12).each do |i|
      data[i] = {}
      data[i][:new] = 0
      data[i][:solved] = 0
      data[i][:unsolved] = 0
      data[i][:total] = 0
      #新增
      data_new.each do |month|
        if month[:month].eql?(i)
          data[i][:new] = month[:num]
        end
      end
      #已解决
      data_close.each do |month|
        if month[:month].eql?(i)
          data[i][:solved] = month[:num]
        end
      end
      #未解决的

      #合计
      data[i][:total] =  data[i][:new] + data[i][:solved] + data[i][:unsolved]
      {:datas => data, :params=>params }
    end

  end

  def data(params={})
      params||={}

      language = I18n.locale
      new_data= Icm::IncidentRequest.select("MONTH(submitted_date)  months  ,count(1) num").
             where("YEAR(submitted_date)=?",params[:year]).
             group(" MONTH(submitted_date) ")
      close_data= Icm::IncidentRequest.joins("JOIN icm_incident_journals ON icm_incident_requests.id=icm_incident_journals.incident_request_id ").
             select("MONTH( icm_incident_journals.created_at)  months  ,count(1)  num").
             where("YEAR(submitted_date)=?",params[:year]).
             where("icm_incident_journals.reply_type='CLOSE'").
             group("MONTH( icm_incident_journals.created_at)")
     # 处理事故单参数
       if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
          new_data = new_data.where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", params[:external_system_id] + [])
          close_data = close_data.where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", params[:external_system_id] + [])

        end


      open_data=[]
      1.upto(12).each do |i|
          open_data_m= Icm::IncidentRequest.select("#{i} months,count(1) num").
              where("icm_incident_requests.submitted_date<=LAST_DAY(CONCAT(?, '-', ?, '-','2'))",params[:year],i).
              where("NOT EXISTS ( SELECT 1 FROM icm_incident_journals WHERE icm_incident_journals.incident_request_id = icm_incident_requests.id
                   AND icm_incident_journals.reply_type = 'CLOSE'
                  AND icm_incident_journals.created_at < LAST_DAY( CONCAT(?, '-', ?, '-', '2')))",params[:year],i)
          # 处理事故单参数
          if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
           open_data_m = open_data_m.where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", params[:external_system_id] + [])

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
      month_headers= I18n.t(:label_report_icm_incident_status_months).split(",")
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