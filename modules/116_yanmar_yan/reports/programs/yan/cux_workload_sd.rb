class Yan::CuxWorkloadSd < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    start_date = params[:start_date]
    unless params[:start_date].present?
      start_date = "1970-1-1"
    end

    end_date = params[:end_date]
    unless params[:end_date].present?
      end_date = "2099-1-1"
    end

    # GPACK-DEV,GPACK-YA DEV, GPACK-YADIN DEV, GPACK-YID DEV
    # 000q00092jgjCXqacqteQS ,000q00093z3PYc92V4IF72 ,000q00093z3PYc92VS8hCi ,000q00093z3PYc92VlBMoq
    #system = "'000q00092jgjCXqacqteQS' ,'000q00093z3PYc92V4IF72' ,'000q00093z3PYc92VS8hCi' ,'000q00093z3PYc92VlBMoq'"

    # except four people Yao Xing, Yongfu Che, Jie Yi和章硕吉
    # '000100091nfeuL4b6vm6Mq', '000100091q1MAdoNPnqwQC', '000100091vW1k2RrWhsiSu', '000100092bMEAsQSw2zmMq'

    except_people = "'000100091nfeuL4b6vm6Mq', '000100091q1MAdoNPnqwQC', '000100091vW1k2RrWhsiSu', '000100092bMEAsQSw2zmMq'"

    system = ""
    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      params[:external_system_id].each do |s|
        temp = "'" + s + "',"
        system << temp
      end
    else
      sys = Irm::ExternalSystem.multilingual.order_with_name.with_dev_sys.enabled.collect(&:id)
      sys.each do |s|
        temp = "'" + s + "',"
        system << temp
      end
    end
    # delete the last  ,
    system = system[0, system.length-1]

    sql = %Q(
        SELECT
          iest.system_name,
          iir.request_number,
          iir.title,
          iir.support_person_id,
          ip3.full_name 'supporter',
          ip1.full_name 'old_supporter_name',
          ip2.full_name 'new_supporter_name',
          iih.request_id,
          iih.old_value,
          iih.new_value,
          iih.created_at,
          iih.property_key
        FROM
          icm_incident_histories iih
        LEFT OUTER JOIN icm_incident_requests iir ON (iih.request_id = iir.id)
        LEFT OUTER JOIN irm_external_systems_tl iest ON (
          iir.external_system_id = iest.external_system_id
          AND iest. LANGUAGE = 'en'
        )
        LEFT OUTER JOIN irm_people ip1 ON (
          iih.old_value = ip1.id
          AND iih.old_value NOT IN (#{except_people})
          AND iih.old_value IN (
            SELECT
              igm.person_id
            FROM
              irm_group_members igm
            WHERE
              igm.group_id = '001400091nvxvi9mGSGGq8'
          )
        )
        LEFT OUTER JOIN irm_people ip2 ON (
          iih.new_value = ip2.id
          AND iih.new_value NOT IN (#{except_people})
          AND iih.new_value IN (
            SELECT
              igm.person_id
            FROM
              irm_group_members igm
            WHERE
              igm.group_id = '001400091nvxvi9mGSGGq8'
          )
        )
        LEFT OUTER JOIN irm_people ip3 ON (iir.support_person_id = ip3.id)
        WHERE
          iih.property_key IN (
            'incident_status_id',
            'support_person_id',
            'support_group_id'
          )
        AND iir.external_system_id IN (#{system})
        AND iir.submitted_date >= '#{start_date}' AND iir.submitted_date <= '#{end_date}'
        ORDER BY
          iir.external_system_id,
          iir.request_number,
          iih.created_at,
          iih.id
    )

    headers = [
        "System",
        "Serial Number",
        "Title",
        "Supporter",
        "Workload"]

    datas = []

    result = ActiveRecord::Base.connection.execute(sql)

    current_request_id = 0
    current_request = {}
    current_status_30_50 = false
    current_sd = false
    current_supporters = {}
    current_supporter_id = nil

    current_real_start_time = nil
    current_real_end_time = nil

    result.each do |s|

      if !current_request_id.eql?(s[7])
        if current_supporters.size > 0
          current_supporters.each do |k, v|
            if v.to_i > 0
              data = Array.new(18)
              data[0] = current_request[:system]
              data[1] = current_request[:number]
              data[2] = current_request[:title]
              data[3] = current_request[k]
              hour = (v/3600).to_i
              min = ((v-hour*3600)/60).to_i
              sec = ((v-hour*3600) % 60).to_i

              data[4] = hour.to_s + "h " + min.to_s + "m " + sec.to_s + "s"
              datas << data
            end

          end
        end
        current_request_id = s[7]
        current_request[:id] = s[7]
        current_request[:system] = s[0]
        current_request[:number] = s[1]
        current_request[:title] = s[2]

        current_status_30_50 = false
        current_sd = false
        current_supporters = {}
        current_real_start_time = nil
        current_real_end_time = nil
      else

      end
      # 11 property_key
      if s[11].eql?("incident_status_id")
        # 如果状态变更为30或者50
        if !(s[8].eql?("000K00091nRTl3hfwbJuHg") || s[8].eql?("000K00091oEOpAuVx0QTVQ")) && (s[9].eql?("000K00091nRTl3hfwbJuHg") || s[9].eql?("000K00091oEOpAuVx0QTVQ"))
          current_status_30_50 = true
          if current_sd && current_supporter_id.present?
            current_real_start_time = s[10]
          end
        end
        # 如果状态从30或50变更为其他状态  s[8]=old_value   s[9]=new_value
        if (s[8].eql?("000K00091nRTl3hfwbJuHg") || s[8].eql?("000K00091oEOpAuVx0QTVQ")) && !(s[9].eql?("000K00091nRTl3hfwbJuHg") || s[9].eql?("000K00091oEOpAuVx0QTVQ"))
          current_status_30_50 = false
          # s[4]=old_supporter_name   s[5]=new_supporter_name
          if current_sd && current_supporter_id.present?
            # current_real_end_time = s[:created_at]
            if current_supporters[current_supporter_id].present?
              current_supporters[current_supporter_id] += (s[10]-current_real_start_time)
            else
              current_supporters[current_supporter_id] = s[10]-current_real_start_time
            end
          end
        end

      elsif s[11].eql?("support_group_id")
        if s[9].eql?("000Q00091nxNqRI7bBNZXU")
          current_sd = true
        end
        if s[8].eql?("000Q00091nxNqRI7bBNZXU")
          current_sd = false
        end

      elsif s[11].eql?("support_person_id")
        if !s[6].nil?
          current_supporter_id = s[9]
          current_request[current_supporter_id] = s[6]
        else
          current_supporter_id = nil
        end

        # 如果支持人员从别的组变更为sd成员
        if current_sd && !s[6].nil? && s[5].nil?
          # 记录该sd成员
          # 如果为30或50，则记录工时开始时间
          if current_status_30_50
            current_real_start_time = s[10]
            if !current_supporters[s[9]].present?
              current_supporters[s[9]] = 0
              current_request[s[9]] = s[6]
            end
          end
        end

        # 如果变化的支持人员同为sd成员
        if current_sd && !s[6].nil? && !s[5].nil?
          # 如果当前状态为30或50，则保存old支持人员的工时
          # 并 更新工时开始计算时间
          if current_status_30_50
            if current_supporters[s[8]].present?
              current_supporters[s[8]] += (s[10]-current_real_start_time)
            else
              current_supporters[s[8]] = s[10]-current_real_start_time
            end

            current_request[s[8]] = s[5]
            if !current_supporters[s[9]].present?
              current_supporters[s[9]] = 0
              current_request[s[9]] = s[6]
            end
            current_real_start_time = s[10]
          end
        end

        # 如果支持人员从sd组成员 变更为其他组成员 （或变更为曾为sd，现不为sd成员）
        if s[6].nil? && !s[5].nil?
          if current_status_30_50
            # 保存 sd组成员工时
            # 如果 current_real_start_time 存在，则说明sd组成员有工时，否则sd成员之前所在状态并不是30或50
            if current_real_start_time.present?
              if current_supporters[s[8]].present?
                current_supporters[s[8]] += (s[10]-current_real_start_time)
              else
                current_supporters[s[8]] = (s[10]-current_real_start_time)
              end
              current_request[s[8]] = s[5]
            end

          end

        end
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