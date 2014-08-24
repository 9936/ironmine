class Boa::BoardsController < ApplicationController
  def index
    @table_a_date = []
    @table_a_submitted_amount = []
    @table_a_closed_amount = []
    @table_a_accum_open_amount = []
    @table_a_accum_close_amount = []
    @table_a_incident_by_category_open = []
    @table_a_incident_by_category_total = []

    @table_a_incident_by_category_open = Icm::IncidentRequest.enabled.joins(",#{Icm::IncidentCategory.view_name} ic").
        select("ic.name category_name, SUM(1) amount").
        where("ic.id = #{Icm::IncidentRequest.table_name}.incident_category_id").
        where("ic.language = 'en'").
        where("NOT EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id)").
        group("#{Icm::IncidentRequest.table_name}.incident_category_id").collect{|i| [i[:category_name], i[:amount].to_i]}

    @table_a_incident_by_category_total = Icm::IncidentRequest.enabled.joins(",#{Icm::IncidentCategory.view_name} ic").
        select("ic.name category_name, SUM(1) amount").
        where("ic.id = #{Icm::IncidentRequest.table_name}.incident_category_id").
        where("ic.language = 'en'").
        group("#{Icm::IncidentRequest.table_name}.incident_category_id").collect{|i| [i[:category_name], i[:amount].to_i]}

    ir_submited_result = Icm::IncidentRequest.enabled.
        select("DATE_FORMAT(submitted_date, '%Y-%m-%d') submitted_date_formatted, SUM(1) submitted_amount").
        where("submitted_date >= ?", (Time.now - 30.days).strftime('%Y-%m-%d')).
        group("DATE_FORMAT(submitted_date, '%Y-%m-%d')").collect{|a| [a[:submitted_date_formatted], a[:submitted_amount]]}

    ir_close_result = Icm::IncidentRequest.enabled.
        select("DATE_FORMAT(last_response_date, '%Y-%m-%d') close_date_formatted, SUM(1) close_amount").
        where("EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND ij.created_at >= ?)", (Time.now - 30.days).strftime('%Y-%m-%d')).
        group("DATE_FORMAT(last_response_date, '%Y-%m-%d')").collect{|a| [a[:close_date_formatted], a[:close_amount]]}

    for today in (Time.now - 30.days).strftime('%Y-%m-%d').to_datetime..Time.now.strftime('%Y-%m-%d').to_datetime do
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

      accum_open_amount = Icm::IncidentRequest.enabled.
          where("(EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND ij.created_at > ?)
               OR NOT EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id)) AND #{Icm::IncidentRequest.table_name}.created_at < ?",
                today.strftime('%Y-%m-%d'), (today + 1.day).strftime('%Y-%m-%d'))

      accum_close_amount = Icm::IncidentRequest.enabled.
          where("(EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND ij.created_at <= ?)
               OR NOT EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id)) AND #{Icm::IncidentRequest.table_name}.created_at < ?",
                today.strftime('%Y-%m-%d'), (today + 1.day).strftime('%Y-%m-%d'))

      @table_a_accum_open_amount << accum_open_amount.size
      @table_a_accum_close_amount << accum_close_amount.size
    end
    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end
end
