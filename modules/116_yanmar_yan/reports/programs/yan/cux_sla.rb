# -*- coding:utf-8 -*-
class Yan::CuxSla < Irm::ReportManager::ReportBase
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

    sql = %Q(SELECT
              '1' `Type`,
              ir.request_number `INC No.`,
              ir.title `Title`,
              ies.system_name `System`,
              isgv.name `Support Group`,
              ip.full_name `Supporter`,
              ipcv.name `Priority`,
              icv.name `Category`,
              iscv.name `Sub-Category`,
              IF(iisv.close_flag = 'Y',
                  'CLOSE',
                  'OPEN') `Status`,
              ir.submitted_date `Creation Time`,
              IF(iisv.close_flag = 'Y',
                  DATE_FORMAT(ir.last_response_date, '%Y-%m-%d %T'),
                  '') `Close Time`,
              ir.last_response_date `Last Response Time`,
              (SELECT
                      MIN(iih4.created_at)
                  FROM
                      icm_incident_histories iih4,
                      irm_people ip4
                  WHERE
                      iih4.request_id = ir.id
                          AND iih4.property_key = 'support_person_id'
                          AND iih4.new_value = ip4.id
                          AND ip4.email_address LIKE '%hand-china.com') `Accept Time`,
             ROUND(((UNIX_TIMESTAMP(
                (SELECT
                          MIN(iih4.created_at)
                      FROM
                          icm_incident_histories iih4,
                          irm_people ip4
                      WHERE
                          iih4.request_id = ir.id
                              AND iih4.property_key = 'support_person_id'
                              AND iih4.new_value = ip4.id
                              AND ip4.email_address LIKE '%hand-china.com'))) - UNIX_TIMESTAMP(ir.submitted_date))/60, 2) `Accept time consuming(M)`,
            ROUND( (UNIX_TIMESTAMP(ir.last_response_date) - UNIX_TIMESTAMP(ir.submitted_date))/3600, 2) `sovled time consuming(H)`,
              IF((SELECT
                          COUNT(1)
                      FROM
                          irm_people ipp,
                          icm_incident_journals ijj,
                          icm_support_groups_vl isgv,
                          irm_group_members igm
                      WHERE
                          NOT EXISTS( SELECT
          1
                              FROM
                                  icm_support_groups_vl isgv,
                                  irm_group_members igm
                              WHERE
                                  ipp.id = igm.person_id
                                      AND igm.group_id = isgv.group_id
                                      AND isgv.id = '000Q00091nxNqRI7bBNZXU')
                              AND ipp.id = ijj.created_at
                              AND ijj.incident_request_id = ir.id
                              AND ijj.reply_type IN ('CUSTOMER_REPLY' , 'OTHER_REPLY', 'SUPPORTER_REPLY')
                              AND ipp.id <> ir.submitted_by) > 0,
                  'N',
                  'Y') `SD Only`,
              (SELECT
                      distinct ircg.name
                  FROM
                      irm_rating_config_grades ircg,
                      irm_ratings irt
                  WHERE
                      irt.rating_object_id = ir.id
                          AND irt.grade = ircg.grade
                          AND ircg.rating_config_id = '004M00091pvgVjGtZKQowS') `Rating`

          FROM
              icm_incident_requests ir,
              icm_incident_histories iihh,
              irm_external_systems_vl ies,
              icm_support_groups_vl isgv,
              irm_people ip,
              icm_priority_codes_vl ipcv,
              icm_incident_categories_vl icv,
              icm_incident_sub_categories_vl iscv,
              icm_incident_statuses_vl iisv
          where
              ir.id = iihh.request_id
                  AND iisv.id = ir.incident_status_id
                  AND iisv.language = 'en'
                  AND ir.incident_category_id = icv.id
                  AND icv.language = 'en'
                  AND ir.incident_sub_category_id = iscv.id
                  AND iscv.language = 'en'
                  AND ir.priority_id = ipcv.id
                  AND ipcv.language = 'en'
                  AND ir.support_person_id = ip.id
                  AND ir.support_group_id = isgv.id
                  AND isgv.language = 'en'
                  AND ir.external_system_id = ies.id
                  AND ies.language = 'en'
                  AND iihh.property_key = 'support_group_id'
                  AND iihh.new_value = '000Q00091nxNqRI7bBNZXU'
                  AND ir.support_group_id = '000Q00091nxNqRI7bBNZXU'
              AND ir.last_response_date >= '#{start_date}'
              AND ir.last_response_date < '#{end_date}'
                  AND iihh.created_at = (SELECT
                      MIN(iih.created_at)
                  FROM
                      icm_incident_histories iih
                  WHERE
                      iih.property_key = 'support_group_id'
                          AND iih.request_id = ir.id
                          AND iih.new_value = '000Q00091nxNqRI7bBNZXU')

          UNION

          SELECT
              '2' `Type`,
              ir.request_number `INC No.`,
              ir.title `Title`,
              ies.system_name `System`,
              isgv.name `Support Group`,
              ip.full_name `Supporter`,
              ipcv.name `Priority`,
              icv.name `Category`,
              iscv.name `Sub-Category`,
              IF(iisv.close_flag = 'Y',
                  'CLOSE',
                  'OPEN') `Status`,
              ir.submitted_date `Creation Time`,
              IF(iisv.close_flag = 'Y',
                  DATE_FORMAT(ir.last_response_date, '%Y-%m-%d %T'),
                  '') `Close Time`,
              ir.last_response_date `Last Response Time`,
              (SELECT
                      MIN(iih4.created_at)
                  FROM
                      icm_incident_histories iih4,
                      irm_people ip4
                  WHERE
                      iih4.request_id = ir.id
                          AND iih4.property_key = 'support_person_id'
                          AND iih4.new_value = ip4.id
                          AND ip4.email_address LIKE '%hand-china.com') `Accept Time`,
              0 `Accept time consuming(M)`,
            ROUND( (UNIX_TIMESTAMP(ir.last_response_date) - UNIX_TIMESTAMP(ir.submitted_date)) /3600,2) `sovled time consuming(H)`,
              IF((SELECT
                          COUNT(1)
                      FROM
                          irm_people ipp,
                          icm_incident_journals ijj,
                          icm_support_groups_vl isgv,
                          irm_group_members igm
                      WHERE
                          NOT EXISTS( SELECT
          1
                              FROM
                                  icm_support_groups_vl isgv,
                                  irm_group_members igm
                              WHERE
                                  ipp.id = igm.person_id
                                      AND igm.group_id = isgv.group_id
                                      AND isgv.id = '000Q00091nxNqRI7bBNZXU')
                              AND ipp.id = ijj.created_at
                              AND ijj.incident_request_id = ir.id
                              AND ijj.reply_type IN ('CUSTOMER_REPLY' , 'OTHER_REPLY', 'SUPPORTER_REPLY')
                              AND ipp.id <> ir.submitted_by) > 0,
                  'N',
                  'Y') `SD Only`,
              (SELECT
                      distinct ircg.name
                  FROM
                      irm_rating_config_grades ircg,
                      irm_ratings irt
                  WHERE
                      irt.rating_object_id = ir.id
                          AND irt.grade = ircg.grade
                          AND ircg.rating_config_id = '004M00091pvgVjGtZKQowS') `Rating`
          FROM
              icm_incident_requests ir,
              icm_incident_histories iihh,
              irm_external_systems_vl ies,
              icm_support_groups_vl isgv,
              irm_people ip,
              icm_priority_codes_vl ipcv,
              icm_incident_categories_vl icv,
              icm_incident_sub_categories_vl iscv,
              icm_incident_statuses_vl iisv
          where
              ir.id = iihh.request_id
                  AND iisv.id = ir.incident_status_id
                  AND iisv.language = 'en'
                  AND ir.incident_category_id = icv.id
                  AND icv.language = 'en'
                  AND ir.incident_sub_category_id = iscv.id
                  AND iscv.language = 'en'
                  AND ir.priority_id = ipcv.id
                  AND ipcv.language = 'en'
                  AND ir.support_person_id = ip.id
                  AND ir.support_group_id = isgv.id
                  AND isgv.language = 'en'
                  AND ir.external_system_id = ies.id
                  AND ies.language = 'en'
                  AND iihh.property_key = 'support_group_id'
                  AND iihh.new_value = '000Q00091nxNqRI7bBNZXU'
                  AND ir.support_group_id = '000Q00091nxNqRI7bBNZXU'
              AND ir.last_response_date >= '#{start_date}'
              AND ir.last_response_date < '#{end_date}'
                  AND iihh.created_at <> (SELECT
                      MIN(iih.created_at)
                  FROM
                      icm_incident_histories iih
                  WHERE
                      iih.property_key = 'support_group_id'
                          AND iih.request_id = ir.id)
                  AND iihh.created_at <> (SELECT
                      MIN(iih.created_at)
                  FROM
                      icm_incident_histories iih
                  WHERE
                      iih.property_key = 'support_group_id'
                          AND iih.request_id = ir.id))

    result = ActiveRecord::Base.connection.execute(sql)
    datas = []
    headers = [
        'TYPE',
        'INC No.',
        'Title',
        'System',
        'Support Group',
        'Supporter',
        'Priority',
        'Category',
        'Sub-Category',
        'Status',
        'Creation Time',
        'Close Time',
        'Last Response Time',
        'Accept Time',
        'Accept Time Consuming(M)',
        'Solved Time Consuming(H)',
        'SD Only',
        'Rating'
    ]

    result.each do |t|
      data = Array.new(18)
      data[0] = t[0]
      data[1] = t[1]
      data[2] = t[2]
      data[3] = t[3]
      data[4] = t[4]
      data[5] = t[5]
      data[6] = t[6]
      data[7] = t[7]
      data[8] = t[8]
      data[9] = t[9]
      data[10] = t[10]
      data[11] = t[11]
      data[12] = t[12]
      data[13] = t[13]
      data[14] = t[14]
      data[15] = t[15]
      data[16] = t[16]
      data[17] = t[17]
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
