class Boy::BoardsController < ApplicationController
  def index
    @table_a_date = []
    @table_a_submitted_amount = []
    @table_a_closed_amount = []
    @table_a_accum_open_amount = []
    @table_a_accum_close_amount = []
    @table_a_incident_by_category_open = []
    @table_a_incident_by_category_total = []
    @table_a_open_by_service_desk = []
    @count_new = Icm::IncidentRequest.enabled.
        select("#{Icm::IncidentRequest.table_name}.request_number request_number, ic.name category_name").
        joins(",#{Icm::IncidentSubCategory.view_name} ic").
        joins(",#{Icm::IncidentStatus.table_name} iis").
        joins(",icm_support_groups_vl isg").
        where("isg.language = 'zh'").
        where("ic.id = #{Icm::IncidentRequest.table_name}.incident_sub_category_id").
        where("ic.language = 'en'").
        where("isg.id = #{Icm::IncidentRequest.table_name}.support_group_id").
        where("isg.name = 'Help Desk'").
        where("#{Icm::IncidentRequest.table_name}.external_system_id IS NOT NULL").
        where("#{Icm::IncidentRequest.table_name}.external_system_id <> '--- Please Select ---'").
        where("iis.id = #{Icm::IncidentRequest.table_name}.incident_status_id").
        where("iis.incident_status_code IN ('NEW', 'NOT_STARTED')").
        order("#{Icm::IncidentRequest.table_name}.created_at DESC")

    @table_a_open_by_service_desk = Icm::IncidentRequest.enabled.
        joins(",#{Icm::IncidentStatus.view_name} isv").
        joins(",icm_support_groups_vl isg").
        where("isg.language = 'zh'").
        where("isg.id = #{Icm::IncidentRequest.table_name}.support_group_id").
        where("isg.name = 'Help Desk'").
        select("isv.name status_name, SUM(1) amount, isv.display_color").
        where("isv.id = #{Icm::IncidentRequest.table_name}.incident_status_id").
        where("isv.language = 'en'").
        where("NOT EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id)").
        group("#{Icm::IncidentRequest.table_name}.incident_status_id").order("isv.display_sequence + 0 ASC").collect{|i| [i[:status_name], i[:amount].to_i, i[:display_color]]}

    @table_a_incident_by_category_open = Icm::IncidentRequest.enabled.joins(",#{Icm::IncidentCategory.view_name} ic").
        select("ic.name category_name, SUM(1) amount").
        joins(",icm_support_groups_vl isg").
        where("isg.language = 'zh'").
        where("isg.id = #{Icm::IncidentRequest.table_name}.support_group_id").
        where("isg.name = 'Help Desk'").
        where("ic.id = #{Icm::IncidentRequest.table_name}.incident_category_id").
        where("ic.language = 'en'").
        where("NOT EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id)").
        group("#{Icm::IncidentRequest.table_name}.incident_category_id").order("ic.code + 0 ASC").collect{|i| [i[:category_name], i[:amount].to_i, '']}

    @table_a_incident_by_category_open.each do |c|
      #c[2] = '#FF0900' if c[0].eql?("Failure")
      c[2] = '#E8AB5D' if c[0].eql?("Inquiry")
      #c[2] = '#FFFEC7' if c[0].eql?("Change Request")
      #c[2] = '#66D6FF' if c[0].eql?("Regular Maintenance")
      #c[2] = '#84FF82' if c[0].eql?("Non-Regular Maintenance")
      c[2] = '#8E5DE8' if c[0].eql?("Operation Request")
      #c[2] = '#A9E2E8' if c[0].eql?("EBS")
    end

    @today_created = []
    @today_created = Icm::IncidentRequest.enabled.joins(",#{Icm::IncidentCategory.view_name} ic").
        select("ic.name category_name, #{Icm::IncidentRequest.table_name}.request_number request_number").
        select("ipv.name priority_name").
        joins(",icm_support_groups_vl isg").
        joins(",icm_priority_codes_vl ipv").
        where("ipv.id = #{Icm::IncidentRequest.table_name}.priority_id").
        where("ipv.language = 'en'").
        where("isg.language = 'zh'").
        where("isg.id = #{Icm::IncidentRequest.table_name}.support_group_id").
        where("isg.name = 'Help Desk'").
        where("ic.id = #{Icm::IncidentRequest.table_name}.incident_category_id").
        where("ic.language = 'en'").
        where("DATE_FORMAT(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m-%d') = ?", (Time.now).strftime('%Y-%m-%d')).
        order("#{Icm::IncidentRequest.table_name}.submitted_date ASC").
        collect{|a| [a[:request_number], a[:category_name], a[:priority_name]]}
    @today_closed = []
    @today_closed = Icm::IncidentRequest.enabled.
        select("ic.name category_name, #{Icm::IncidentRequest.table_name}.request_number request_number").
        select("ipv.name priority_name").
        joins(",#{Icm::IncidentCategory.view_name} ic").
        joins(",icm_support_groups_vl isg").
        joins(",icm_priority_codes_vl ipv").
        where("ipv.id = #{Icm::IncidentRequest.table_name}.priority_id").
        where("ipv.language = 'en'").
        where("isg.name = 'Help Desk'").
        where("isg.language = 'zh'").
        where("ic.id = #{Icm::IncidentRequest.table_name}.incident_category_id").
        where("ic.language = 'en'").
        where("isg.id = #{Icm::IncidentRequest.table_name}.support_group_id").
        where("isg.name = 'Help Desk'").
        where("EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND DATE_FORMAT(ij.created_at, '%Y-%m-%d') = ?)",
              (Time.now).strftime('%Y-%m-%d')).
        order("#{Icm::IncidentRequest.table_name}.last_response_date ASC").
        collect{|a| [a[:request_number], a[:category_name], a[:priority_name]]}
    @processing_list = []
    @processing_list = Icm::IncidentRequest.enabled.joins(",#{Icm::IncidentCategory.view_name} ic").
        select("ic.name category_name, #{Icm::IncidentRequest.table_name}.request_number request_number, #{Icm::IncidentRequest.table_name}.last_response_date last_response_date").
        joins(",icm_support_groups_vl isg").
        where("isg.language = 'zh'").
        where("isg.id = #{Icm::IncidentRequest.table_name}.support_group_id").
        where("isg.name = 'Help Desk'").
        where("ic.id = #{Icm::IncidentRequest.table_name}.incident_category_id").
        where("ic.language = 'en'").
        where("#{Icm::IncidentRequest.table_name}.incident_status_id IN (?)", ["000K00091nRTl3hfwbJuHg","000K00091oEOpAuVx0QTVQ", "000K00091nRTl3hfuk332W"]).
        order("#{Icm::IncidentRequest.table_name}.last_response_date DESC").
        collect{|a| [a[:request_number], a[:category_name], a[:last_response_date]]}
    @daily_open = []
    @daily_close = []
    @daily_avg_open = []
    @daily_avg_close = []

    update_flag = false

    logs = ActiveRecord::Base.connection.execute("SELECT today_create `0`, today_close `1`, today_avg_create `2`, today_avg_close `3`, created_date `4` FROM icm_prime_board_logs WHERE created_date = '#{(Time.now - 1.day).strftime('%Y%m%d')}'")
    if logs.any?
      update_flag = false
    else
      update_flag = true
    end

    for today in (Time.now - 21.days).strftime('%Y-%m-%d').to_datetime..(Time.now - 1.day).strftime('%Y-%m-%d').to_datetime do
      if update_flag
        today_create = Icm::IncidentRequest.
                        where("DATE_FORMAT(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m-%d') = ?", today.strftime('%Y-%m-%d')).
                        joins(",icm_support_groups_vl isg").
                        where("isg.language = 'zh'").
                        where("isg.id = #{Icm::IncidentRequest.table_name}.support_group_id").
                        where("isg.name = 'Help Desk'").
                        where("#{Icm::IncidentRequest.table_name}.external_system_id IS NOT NULL").
                        where("#{Icm::IncidentRequest.table_name}.external_system_id <> '--- Please Select ---'").size
        today_close = Icm::IncidentRequest.enabled.
            joins(",#{Icm::IncidentCategory.view_name} ic").
            joins(",icm_support_groups_vl isg").
            where("isg.name = 'Help Desk'").
            where("isg.language = 'zh'").
            where("ic.id = #{Icm::IncidentRequest.table_name}.incident_category_id").
            where("ic.language = 'en'").
            where("isg.id = #{Icm::IncidentRequest.table_name}.support_group_id").
            where("isg.name = 'Help Desk'").
            where("EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND DATE_FORMAT(ij.created_at, '%Y-%m-%d') = ?)",
                  today.strftime('%Y-%m-%d')).size
        today_avg_create = Icm::IncidentRequest.
            where("DATE_FORMAT(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m-%d') >= ?", (today - 6.day).strftime('%Y-%m-%d')).
            where("DATE_FORMAT(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m-%d') <= ?", today.strftime('%Y-%m-%d')).
            joins(",icm_support_groups_vl isg").
            where("isg.language = 'zh'").
            where("isg.id = #{Icm::IncidentRequest.table_name}.support_group_id").
            where("isg.name = 'Help Desk'").
            where("#{Icm::IncidentRequest.table_name}.external_system_id IS NOT NULL").
            where("#{Icm::IncidentRequest.table_name}.external_system_id <> '--- Please Select ---'").size

        today_avg_create = (today_avg_create.to_f/7).round(2)

        today_avg_close = Icm::IncidentRequest.enabled.
            joins(",#{Icm::IncidentCategory.view_name} ic").
            joins(",icm_support_groups_vl isg").
            where("isg.name = 'Help Desk'").
            where("isg.language = 'zh'").
            where("ic.id = #{Icm::IncidentRequest.table_name}.incident_category_id").
            where("ic.language = 'en'").
            where("isg.id = #{Icm::IncidentRequest.table_name}.support_group_id").
            where("isg.name = 'Help Desk'").
            where("EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND DATE_FORMAT(ij.created_at, '%Y-%m-%d') >= ?)",
                  (today - 6.day).strftime('%Y-%m-%d')).
            where("EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND DATE_FORMAT(ij.created_at, '%Y-%m-%d') <= ?)",
                  today.strftime('%Y-%m-%d')).size

        today_avg_close = (today_avg_close.to_f/7).round(2)

        logs = ActiveRecord::Base.connection.execute("SELECT today_create `0`, today_close `1`, today_avg_create `2`, today_avg_close `3`, created_date `4` FROM icm_prime_board_logs WHERE created_date = '#{today.strftime('%Y%m%d')}'")

        if logs.any?
          ActiveRecord::Base.connection.execute(%Q(UPDATE icm_prime_board_logs SET today_create = '#{today_create}', today_close = '#{today_close}',
                                                today_avg_create = '#{today_avg_create}', today_avg_close = '#{today_avg_close}' WHERE created_date  = '#{today.strftime('%Y%m%d')}'
                  ))
        else
          begin
            ActiveRecord::Base.connection.execute(%Q(INSERT INTO icm_prime_board_logs (today_create, today_close, today_avg_create, today_avg_close, created_date) VALUES
                      ('#{today_create}', '#{today_close}', '#{today_avg_create}', '#{today_avg_close}', '#{today.strftime('%Y%m%d')}')
                    ))
          rescue
            nil
          end
        end
      end

      logs = ActiveRecord::Base.connection.execute("SELECT today_create `0`, today_close `1`, today_avg_create `2`, today_avg_close `3`, created_date `4` FROM icm_prime_board_logs WHERE created_date = '#{today.strftime('%Y%m%d')}'")

      @daily_open << logs.first[0]
      @daily_close << logs.first[1]
      @daily_avg_open << logs.first[2]
      @daily_avg_close << logs.first[3]

      @table_a_date << today.strftime('%m/%d')
    end

    today_create = Icm::IncidentRequest.
        where("DATE_FORMAT(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m-%d') = ?", Time.now.strftime('%Y-%m-%d')).
        joins(",icm_support_groups_vl isg").
        where("isg.language = 'zh'").
        where("isg.id = #{Icm::IncidentRequest.table_name}.support_group_id").
        where("isg.name = 'Help Desk'").
        where("#{Icm::IncidentRequest.table_name}.external_system_id IS NOT NULL").
        where("#{Icm::IncidentRequest.table_name}.external_system_id <> '--- Please Select ---'").size
    today_close = Icm::IncidentRequest.enabled.
        joins(",#{Icm::IncidentCategory.view_name} ic").
        joins(",icm_support_groups_vl isg").
        where("isg.name = 'Help Desk'").
        where("isg.language = 'zh'").
        where("ic.id = #{Icm::IncidentRequest.table_name}.incident_category_id").
        where("ic.language = 'en'").
        where("isg.id = #{Icm::IncidentRequest.table_name}.support_group_id").
        where("isg.name = 'Help Desk'").
        where("EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND DATE_FORMAT(ij.created_at, '%Y-%m-%d') = ?)",
              Time.now.strftime('%Y-%m-%d')).size
    today_avg_create = Icm::IncidentRequest.
        where("DATE_FORMAT(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m-%d') >= ?", (Time.now - 7.day).strftime('%Y-%m-%d')).
        joins(",icm_support_groups_vl isg").
        where("isg.language = 'zh'").
        where("isg.id = #{Icm::IncidentRequest.table_name}.support_group_id").
        where("isg.name = 'Help Desk'").
        where("#{Icm::IncidentRequest.table_name}.external_system_id IS NOT NULL").
        where("#{Icm::IncidentRequest.table_name}.external_system_id <> '--- Please Select ---'").size

    today_avg_create = (today_avg_create.to_f/7).round(2)

    today_avg_close = Icm::IncidentRequest.enabled.
        joins(",#{Icm::IncidentCategory.view_name} ic").
        joins(",icm_support_groups_vl isg").
        where("isg.name = 'Help Desk'").
        where("isg.language = 'zh'").
        where("ic.id = #{Icm::IncidentRequest.table_name}.incident_category_id").
        where("ic.language = 'en'").
        where("isg.id = #{Icm::IncidentRequest.table_name}.support_group_id").
        where("isg.name = 'Help Desk'").
        where("EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND DATE_FORMAT(ij.created_at, '%Y-%m-%d') >= ?)",
              (Time.now - 7.day).strftime('%Y-%m-%d')).size

    today_avg_close = (today_avg_close.to_f/7).round(2)

    @daily_open << today_create
    @daily_close << today_close
    @daily_avg_open << today_avg_create
    @daily_avg_close << today_avg_close
    @table_a_date << Time.now.strftime('%m/%d')

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end
end
