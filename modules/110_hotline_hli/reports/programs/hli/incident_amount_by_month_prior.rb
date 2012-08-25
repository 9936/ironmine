class Hli::IncidentAmountByMonthPrior < Irm::ReportManager::ReportBase
  def data(params={})
    #params={:year_from=>2012,:year_to=>2012,:month_from=>2,:month_to=>2}
    #close_status_id = Icm::IncidentStatus.where("incident_status_code = ?", 'CLOSE').first.id
    static_data= Icm::IncidentRequest.
        select("DATE_FORMAT(submitted_date,'%Y-%m')   months  ,priority_id,count(1) num").enabled.
        where("hotline = ?", Irm::Constant::SYS_YES).
        #where("incident_status_id = ?", close_status_id).
        group(" DATE_FORMAT(submitted_date,'%Y-%m') ,priority_id ")

   # 处理事故单参数
     if params[:year_from].present?&&params[:year_to].present?&&params[:month_from].present?&&params[:month_to].present?
        year_from=params[:year_from].to_i
        year_to=params[:year_to].to_i
        month_from=params[:month_from].to_i
        month_to=params[:month_to].to_i
        date_from=DateTime.new(year_from,month_from,1,0,0,0)
        date_to= DateTime.new(year_to,month_to,1).end_of_month.change(:hour=>23,:min=>59,:sec=>59)
        static_data=static_data.where("submitted_date between ? and ?",date_from,date_to)
        return {:datas=>{},:headers=>{},:params=>{}} if date_from>date_to
     else
       return {:datas=>{},:headers=>{},:params=>{}}
     end

    #取出列标题，即优先级 从低到高排序
    priors=Icm::PriorityCode.multilingual.enabled.order("weight_values desc")

    #构造列标题数组
    col_headers=priors.collect {|i| i[:name]}
    # 计算报表最终行数，包括合计行
    row_count=(year_to-year_from)*12+(month_to-month_from+1)+1

    # 构造行标题 数组
    row_headers=Array.new()
    end_date=Date.new(year_to,month_to)
    start_date=Date.new(year_from,month_from)
    Date::DATE_FORMATS[:year_month] = "%Y-%m"
    while(end_date>=start_date)
        row_headers<<start_date.to_s(:year_month)
        start_date=start_date.next_month
    end

    datas=Array.new(row_count,0)   #定义存储所有行数据的大数组
    # 填充主体数据
    static_data.group_by {|s| s['months']}.each do |months,group_static_data|
       data=Array.new(priors.length+2,0)
       index=row_headers.index(months)
       data[0]=months
        group_static_data.each do |g|
           idx=priors.index {|i| i.id.eql? g['priority_id']}

           data[idx+1]=g['num']

        end
       datas[index]=data
    end

    #填充行标题
     datas.each_with_index do |d,index|

       if !d.is_a?(Array)
          data=Array.new(priors.length+2,0)
          data[0]=row_headers[index]
          datas[index]=data
       end

     end
     datas[datas.length-1][0]=I18n.t(:label_report_icm_incident_total)

    #计算每行合计
    datas.each do |data|
      sum_row = data[1..data.length-2].reduce(:+) #不计算行标题和行合计，只加上中间的值
      data[data.length-1]=sum_row
    end
    #计算每列合计
    1.upto(priors.length+1) do |index|
        sum_col=0
         datas.each do |d|
           if(d.is_a?(Array))
             sum_col=sum_col+d[index]
           end
         end
        datas[datas.length-1][index]=sum_col
      end

    {:datas=>datas,:headers=>col_headers,:params=>params}
  end

  def to_xls(params)
    columns = []

    result = data(params)
    columns <<{:key=>0.to_s.to_sym,:label=> I18n.t(:label_report_icm_incident_params_month) }
    result[:headers].each_with_index do |sh,index|
       columns << {:key=>(index+1).to_s.to_sym,:label=>sh}

    end
    columns << {:key=>(result[:headers].length+1).to_s.to_sym,:label=>I18n.t(:label_report_icm_incident_total) }

    excel_data = []
    result[:datas].each_with_index do |data,index|
      excel_data << data.to_cus_hash
    end

    excel_data.to_xls(columns,{})
  end


end