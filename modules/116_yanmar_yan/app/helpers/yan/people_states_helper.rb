module Yan::PeopleStatesHelper
  def init_available_people
    html = ''
    # 搜索逻辑--->若该顾问没有对应30或者50状态的单子且在线则符合条件
    Irm::Person.enabled.
        joins("LEFT OUTER JOIN yan_people_states yps on yps.person_id = #{Irm::Person.table_name}.id").
        where("NOT EXISTS (
            SELECT * from icm_incident_requests
            where support_person_id = #{Irm::Person.table_name}.id
            and incident_status_id in ('000K00091nRTl3hfwbJuHg','000K00091oEOpAuVx0QTVQ')
          )
          AND #{Irm::Person.table_name}.email_address like '%hand-china.com%'
          and yps.state = 'ENABLED'
          and yps.updated_at >= ?
        ",Time.now - 5.minutes).collect { |p|
      html += "<tr><td>#{p.full_name}</td></tr>"
    }
    html.html_safe
  end

  def init_busy_people
    html = ''
    # 搜索逻辑--->若该顾问有对应30或者50状态的单子且在线则符合条件
    Irm::Person.enabled.
        joins("LEFT OUTER JOIN yan_people_states yps on yps.person_id = #{Irm::Person.table_name}.id").
        where("EXISTS (
            SELECT * from icm_incident_requests
            where support_person_id = #{Irm::Person.table_name}.id
            and incident_status_id in ('000K00091nRTl3hfwbJuHg','000K00091oEOpAuVx0QTVQ')
          )
          AND #{Irm::Person.table_name}.email_address like '%hand-china.com%'
          and yps.state = 'ENABLED' and yps.updated_at >= ?
        ",Time.now - 5.minutes).collect { |p|
       html += "<tr><td>#{p.full_name}</td></tr>"
    }
    html.html_safe
  end

  def init_offline_people
    html = ''
    Irm::Person.enabled.
        joins("LEFT OUTER JOIN yan_people_states yps on yps.person_id = #{Irm::Person.table_name}.id").
        # where("NOT EXISTS (
        #     SELECT * from icm_incident_requests
        #     where support_person_id = #{Irm::Person.table_name}.id
        #     and incident_status_id in ('000K00091nRTl3hfwbJuHg','000K00091oEOpAuVx0QTVQ')
        #   )").
        where("#{Irm::Person.table_name}.email_address like '%hand-china.com%'").
        where("yps.state = 'DISABLED' or (yps.state = 'ENABLED' and yps.updated_at < ?)",Time.now - 5.minutes).collect { |p|
      html += "<tr><td>#{p.full_name}</td></tr>"
    }

    html.html_safe
  end

end
