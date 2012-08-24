class Hli::IncidentAmountByMonthCate < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    #获取基本数据
    month_data= Icm::IncidentRequest.select("MONTH(submitted_date)  months, CONCAT(incident_category_id,',',incident_sub_category_id) category,count(1)  amount").enabled.
           where("YEAR(submitted_date)=?",params[:year]).group(" MONTH(submitted_date) , CONCAT(incident_category_id,',',incident_sub_category_id)").
           where("incident_category_id is not null")
    # 处理事故单参数
    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      month_data = month_data.where("external_system_id IN (?)", params[:external_system_id] + [])
    end
    if(params[:is_report].present?)
      month_data = month_data.where("#{Icm::IncidentRequest.table_name}.hotline = ?",params[:is_report])
    end


     # 读取系统中所有事故单服务类别
     categories = Icm::IncidentCategory.multilingual.enabled
     sub_categories = Icm::IncidentSubCategory.multilingual.enabled
     #从统计数据中提取类别列
     my_cates=month_data.collect {|i| i.category}
     my_cates=my_cates.uniq.delete_if {|x| x==nil or x==','}   #去除重复的和空的和仅包含逗号的类别

     #生成列标题
     cate_headers=[]
     my_cates.each_with_index do |cate,index|
       if (cate.end_with?(","))
          category =  categories.detect{|c| c.id.eql?(cate.sub(/,/,''))}
          if category
            cate_headers[index] = category[:name]
          else
            cate_headers[index] =""
          end
       else
          cates_a=cate.split(",")

          category =  categories.detect{|c| c.id.eql?(cates_a[0])}
          subcategory=sub_categories.detect{|c| c.id.eql?(cates_a[1])}
          cate_headers[index] = category[:name]+'-'+subcategory[:name]


       end
     end

     cate_headers<<I18n.t(:label_report_icm_incident_total)
     month_headers= I18n.t(:label_report_icm_incident_months).split(",")

     # 对取得的数据进行处理
    datas = Array.new(13)   #创建13行数据，分别代表12个月和合计行

     month_data.group_by{|i| i[:months]}.each do |months,group_month_data|
       data = Array.new(my_cates.length+2,0) #创建类别数+2列
       sum_row=0 #用于统计行合计
      group_month_data.each do |g_data|
        index = my_cates.index(g_data[:category])
        if index
         data[index+1] = g_data[:amount] #填充行数据
         sum_row=sum_row+data[index+1]
        end
      end
       data[my_cates.length+1]=sum_row   #填充合计行
      #将每一行数据填充到大数组里的特定位置 ,如1月的数据放到数组的 0位置上
        datas[months-1]=data
     end

    #填补月份的行标题
    (0..12).each do |n|
      if(!datas[n])
        datas[n]=Array.new(my_cates.length+2,0)
      end
      datas[n][0]=month_headers[n]
    end

      #计算下方合计

      0.upto(my_cates.length+1) do |index|
        sum_col=0
         if index==0
           next  #行标题不参与计算
         end
         datas.each do |d|
           if(d.is_a?(Array))
             sum_col=sum_col+d[index]
           end
         end
        datas[12][index]=sum_col
      end




    {:datas=>datas,:cate_headers=>cate_headers,:params=>params}
  end

  def to_xls(params)
    columns = []

    result = data(params)

    result[:cate_headers].each_with_index do |sh,index|
      if(index==0)
         columns<<{:key=>index.to_s.to_sym,:label=>I18n.t(:label_report_icm_incident_category)}
      else
         columns << {:key=>index.to_s.to_sym,:label=>sh}
      end
    end

    excel_data = []
    result[:datas].each_with_index do |data,index|
      excel_data << data.to_cus_hash
    end

    excel_data.to_xls(columns,{})
  end


end