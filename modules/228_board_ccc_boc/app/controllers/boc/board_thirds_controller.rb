# -*- coding: utf-8 -*-
class Boc::BoardThirdsController < ApplicationController
  def index
    @table_a_month = []
    months = []
    for month in (Time.now - 5.months).strftime('%Y-%m-%d').to_datetime..Time.now.strftime('%Y-%m-%d').to_datetime do
      if !@table_a_month.include?(month.strftime('%m/%Y'))
        @table_a_month << month.strftime('%m/%Y')
        months << month.strftime('%Y-%m')
      end
    end
    # 新增需求类单数
    @month_need_create = []
    # 其他类单数
    @month_other_create = []
    # 新增需求类工时
    @month_need_workload = []
    # 其他类工时
    @month_other_workload = []
    months.each do |m|
      # 新增需求类
      @month_need_create << Icm::IncidentRequest.enabled.
          where("#{Icm::IncidentRequest.table_name}.request_type_code = '新增需求'").
          where("DATE_FORMAT(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m') = ?", m).size #当月事故单条件
      need_workload = Icm::IncidentJournal.
          select("sum(#{Icm::IncidentJournal.table_name}.workload) workload").
          joins("LEFT OUTER JOIN icm_incident_requests iir on iir.id = #{Icm::IncidentJournal.table_name}.incident_request_id").
          where("(#{Icm::IncidentJournal.table_name}.reply_type = 'SUPPORTER_REPLY' or #{Icm::IncidentJournal.table_name}.reply_type = 'OTHER_REPLY') and iir.request_type_code = '新增需求'").
          where("DATE_FORMAT(#{Icm::IncidentJournal.table_name}.created_at, '%Y-%m') = ?", m).first().workload #当月工时条件
      if need_workload.present?
        @month_need_workload << need_workload.round(1)
      else
        @month_need_workload << 0
      end
      # 其他类
      @month_other_create << Icm::IncidentRequest.enabled.
          where("#{Icm::IncidentRequest.table_name}.request_type_code != '新增需求'").
          where("DATE_FORMAT(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m') = ?", m).size #当月事故单条件

      other_workload = Icm::IncidentJournal.
          select("sum(#{Icm::IncidentJournal.table_name}.workload) workload").
          joins("LEFT OUTER JOIN icm_incident_requests iir on iir.id = #{Icm::IncidentJournal.table_name}.incident_request_id").
          where("(#{Icm::IncidentJournal.table_name}.reply_type = 'SUPPORTER_REPLY' or #{Icm::IncidentJournal.table_name}.reply_type = 'OTHER_REPLY') and iir.request_type_code != '新增需求'").
          where("DATE_FORMAT(#{Icm::IncidentJournal.table_name}.created_at, '%Y-%m') = ?", m).first().workload
      if other_workload.present?
        @month_other_workload << other_workload.round(1)
      else
        @month_other_workload << 0
      end
    end

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end
end
