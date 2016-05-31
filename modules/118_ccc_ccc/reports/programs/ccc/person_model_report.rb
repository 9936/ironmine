# -*- coding: utf-8 -*-
class Ccc::PersonModelReport < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    array = Irm::Person.with_profile_name(I18n.locale)

    if params[:email_address].present?
      array = array.where("email_address like '%#{params[:email_address]}%'")
    end
    if params[:login_name].present?
      array = array.where("login_name like '%#{params[:login_name]}%'")
    end
    # 下拉框单选                                  该条件 就传一个值 并且输出id
    if params[:job_name].present?
       array = array.where("profile_id = '#{params[:job_name]}'")
    end
    # 下拉框复选                        避免传空id                     数组第一个不能为空
    if params[:com_name].present? && params[:com_name].size > 0 && params[:com_name][0].present?
      array = array.where("organization_id IN (?)", params[:com_name])
    end
    # 限制最后登录时间
    #  前面只是一个变量   后面是一个参数连接html页面  每个参数有每个参数的意义
    end_date = params[:end_date]
    unless params[:end_date].present?
      #给一个默认值
      end_date = "2015-9-1"
    end
    if params[:end_date].present?
      # 一个数据库限制字段一个ruby语言的限制字段要一样
      array = array.where("date_format(irm_people.last_login_at, '%Y-%m-%d') <= ?", Date.strptime("#{end_date}", '%Y-%m-%d').strftime("%Y-%m-%d"))
    end
    start_date = params[:start_date]
    unless params[:start_date].present?
      #给一个默认值
      start_date = "2014-9-1"
    end
    array = array.where("date_format(irm_people.last_login_at, '%Y-%m-%d') >= ?", Date.strptime("#{start_date}", '%Y-%m-%d').strftime("%Y-%m-%d"))

    language = []
    if params[:language_id_zh].present?
      language << params[:language_id_zh]
    end
    if params[:language_id_en].present?
      language << params[:language_id_en]
    end
    if params[:language_id_ja].present?
      language << params[:language_id_ja]
    end
    if language.length > 0
      array= array.where("language_code in (?) ",language)
    end

    puts 11111
    puts params[:sex]
    if params[:sex].present?
      # 传过来的值是一个精确值
      array = array.where("sex_id = '#{params[:sex]}'")
    end


    datas = []

    headers = [
       "用户名","登录名","邮箱","联系方式","公司名","简档"
    ]


    array.each do |s|

      data = Array.new(6)
      data[0] = s[:first_name]
      data[1] = s[:login_name]
      data[2] = s[:email_address]
      data[3] = s[:bussiness_phone]
      data[4] = s[:com_name]
      data[5] = s[:job_name]




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
end
