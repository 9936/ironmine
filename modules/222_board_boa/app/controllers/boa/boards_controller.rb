class Boa::BoardsController < ApplicationController
  def index
    @table_a_date = []
    @table_a_submitted_amount = []
    @table_a_closed_amount = []
    @table_a_accum_open_amount = []
    @table_a_accum_close_amount = []
    @table_a_incident_by_category_open = []
    @table_a_incident_by_category_total = []
    @table_a_open_by_service_desk = []

    @table_a_open_by_service_desk = Icm::IncidentRequest.enabled.
        joins(",#{Icm::IncidentStatus.view_name} isv").
        joins(",icm_support_groups_vl isg").
        where("isg.language = 'zh'").
        where("isg.id = #{Icm::IncidentRequest.table_name}.support_group_id").
        where("isg.name = 'Service Desk'").
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
        where("isg.name = 'Service Desk'").
        where("ic.id = #{Icm::IncidentRequest.table_name}.incident_category_id").
        where("ic.language = 'en'").
        where("NOT EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id)").
        group("#{Icm::IncidentRequest.table_name}.incident_category_id").order("ic.code + 0 ASC").collect{|i| [i[:category_name], i[:amount].to_i, '']}

    @table_a_incident_by_category_open.each do |c|
      c[2] = '#FF0900' if c[0].eql?("Failure")
      c[2] = '#E8AB5D' if c[0].eql?("Inquiry")
      c[2] = '#FFFEC7' if c[0].eql?("Change Request")
      c[2] = '#66D6FF' if c[0].eql?("Regular Maintenance")
      c[2] = '#84FF82' if c[0].eql?("Non-Regular Maintenance")
      c[2] = '#8E5DE8' if c[0].eql?("Master Maintenance")
      c[2] = '#A9E2E8' if c[0].eql?("EBS")
    end

    @table_a_incident_by_category_total = Icm::IncidentRequest.enabled.joins(",#{Icm::IncidentCategory.view_name} ic").
        joins(",icm_support_groups_vl isg").
        where("isg.language = 'zh'").
        where("isg.id = #{Icm::IncidentRequest.table_name}.support_group_id").
        where("isg.name = 'Service Desk'").
        select("ic.name category_name, SUM(1) amount").
        where("ic.id = #{Icm::IncidentRequest.table_name}.incident_category_id").
        where("ic.language = 'en'").
        group("#{Icm::IncidentRequest.table_name}.incident_category_id").collect{|i| [i[:category_name], i[:amount].to_i]}

    ir_submited_result = Icm::IncidentRequest.enabled.
        joins(",icm_support_groups_vl isg").
        where("isg.language = 'zh'").
        where("isg.id = #{Icm::IncidentRequest.table_name}.support_group_id").
        where("isg.name = 'Service Desk'").
        select("DATE_FORMAT(submitted_date, '%Y-%m-%d') submitted_date_formatted, SUM(1) submitted_amount").
        where("submitted_date >= ?", (Time.now - 44.days).strftime('%Y-%m-%d')).
        group("DATE_FORMAT(submitted_date, '%Y-%m-%d')").collect{|a| [a[:submitted_date_formatted], a[:submitted_amount]]}

    ir_close_result = Icm::IncidentRequest.enabled.
        select("DATE_FORMAT(last_response_date, '%Y-%m-%d') close_date_formatted, SUM(1) close_amount").
        where("EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND ij.created_at >= ?)", (Time.now - 44.days).strftime('%Y-%m-%d')).
        group("DATE_FORMAT(last_response_date, '%Y-%m-%d')").collect{|a| [a[:close_date_formatted], a[:close_amount]]}
    incident_realtime_array = ['Master Maintenance', 'Change Request', 'Regular Maintenance', 'Non-Regular Maintenance']
    @incident_realtime_result_array = []
    incident_realtime_array.each do |ira|
      incident_realtime_result = Icm::IncidentCategory.
          select("count(*) issue_realtime_amount, ic.name issue_type").
          joins(",#{Icm::IncidentCategory.view_name} ic").
          where("ic.id = #{Icm::IncidentCategory.table_name}.id").
          where("ic.language = 'en'").
          where(%Q(EXISTS( SELECT
            *
        FROM
            icm_incident_requests ir,
            icm_incident_statuses iis
        WHERE
            iis.id = ir.incident_status_id
                AND iis.close_flag = 'N'
                AND ir.status_code = 'ENABLED'
                AND ir.incident_category_id = ic.id))).
          where("ic.name = ?", ira).
          group("ic.name")
      incident_realtime_priority_result = Icm::IncidentCategory.
          select("count(*) issue_realtime_amount, ic.name issue_type").
          joins(",#{Icm::IncidentCategory.view_name} ic").
          where("ic.id = #{Icm::IncidentCategory.table_name}.id").
          where("ic.language = 'en'").
          where(%Q(EXISTS( SELECT
            *
        FROM
            icm_incident_requests ir,
            icm_incident_statuses iis,
            icm_priority_codes ipc
        WHERE
            ipc.id = ir.priority_id
            AND ipc.weight_values > 3
            AND iis.id = ir.incident_status_id
            AND iis.close_flag = 'N'
            AND ir.status_code = 'ENABLED'
            AND ir.incident_category_id = ic.id))).
          where("ic.name = ?", ira).
          group("ic.name")
      if incident_realtime_result.any?
        incident_realtime_result = incident_realtime_result.first[:issue_realtime_amount]
      else
        incident_realtime_result = '0'
      end
      if incident_realtime_priority_result.any?
        incident_realtime_priority_result = incident_realtime_priority_result.first[:issue_realtime_amount]
      else
        incident_realtime_priority_result = '0'
      end
      cell_array = [ira, incident_realtime_result, incident_realtime_priority_result]
      @incident_realtime_result_array << cell_array
    end

    issue_realtime_array = ['SCM' , 'MFG', 'PRC', 'FIN', 'HR', 'Service', 'Master', 'BI', 'JOB', 'Infra', 'About Login']
    @issue_realtime_result_array = []
    issue_realtime_array.each do |ira|
      failure_realtime_result = Icm::IncidentCategory.
          select("count(*) issue_realtime_amount, ic.name issue_type").
          joins(",#{Icm::IncidentSubCategory.view_name} isc").
          joins(",#{Icm::IncidentCategory.view_name} ic").
          where("ic.id = #{Icm::IncidentCategory.table_name}.id").
          where("ic.id = isc.incident_category_id").
          where("ic.language = 'en'").
          where("isc.language = 'en'").
          where(%Q(EXISTS( SELECT
            *
        FROM
            icm_incident_requests ir,
            icm_incident_statuses iis
        WHERE
            iis.id = ir.incident_status_id
                AND iis.close_flag = 'N'
                AND ir.status_code = 'ENABLED'
                AND ir.incident_sub_category_id = isc.id
                AND ir.incident_category_id = ic.id))).
          where(" isc.name = ?", ira).
          where("ic.name = 'Failure'").
          group("ic.name")
      inquiry_realtime_result = Icm::IncidentCategory.
          select("count(*) issue_realtime_amount, ic.name issue_type").
          joins(",#{Icm::IncidentSubCategory.view_name} isc").
          joins(",#{Icm::IncidentCategory.view_name} ic").
          where("ic.id = #{Icm::IncidentCategory.table_name}.id").
          where("ic.id = isc.incident_category_id").
          where("ic.language = 'en'").
          where("isc.language = 'en'").
          where(%Q(EXISTS( SELECT
            *
        FROM
            icm_incident_requests ir,
            icm_incident_statuses iis
        WHERE
            iis.id = ir.incident_status_id
                AND iis.close_flag = 'N'
                AND ir.status_code = 'ENABLED'
                AND ir.incident_sub_category_id = isc.id
                AND ir.incident_category_id = ic.id))).
          where(" isc.name = ?", ira).
          where("ic.name = 'Inquiry'").
          group("ic.name")
      if failure_realtime_result.any?
        failure_realtime_result = failure_realtime_result.first[:issue_realtime_amount]
      else
        failure_realtime_result = '0'
      end
      if inquiry_realtime_result.any?
        inquiry_realtime_result = inquiry_realtime_result.first[:issue_realtime_amount]
      else
        inquiry_realtime_result = '0'
      end
      cell_array = [ira, failure_realtime_result, inquiry_realtime_result]
      @issue_realtime_result_array << cell_array
    end

    for today in (Time.now - 44.days).strftime('%Y-%m-%d').to_datetime..(Time.now - 30.days).strftime('%Y-%m-%d').to_datetime do
      ir_submitted = ir_submited_result.select{|i| i[0] == today.strftime('%Y-%m-%d')}
      ir_closed = ir_close_result.select{|i| i[0] == today.strftime('%Y-%m-%d')}
      @table_a_date << today.strftime('%m/%d')
      if ir_submitted.size > 0
        @table_a_submitted_amount << ir_submitted[0][1]
      else
        @table_a_submitted_amount << 0
      end
      if ir_closed.size > 0
        @table_a_closed_amount << ir_closed[0][1]
      else
        @table_a_closed_amount << 0
      end

      #accum_open_amount = Icm::IncidentRequest.enabled.
      #    where("(EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND ij.created_at > ?)
      #         OR NOT EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id)) AND #{Icm::IncidentRequest.table_name}.created_at < ?",
      #          today.strftime('%Y-%m-%d'), (today + 1.day).strftime('%Y-%m-%d'))
      #
      #accum_close_amount = Icm::IncidentRequest.enabled.
      #    where("(EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND ij.created_at <= ?)
      #         OR NOT EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id)) AND #{Icm::IncidentRequest.table_name}.created_at < ?",
      #          today.strftime('%Y-%m-%d'), (today + 1.day).strftime('%Y-%m-%d'))
      #
      #@table_a_accum_open_amount << accum_open_amount.size
      #@table_a_accum_close_amount << accum_close_amount.size
    end
    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end
end
