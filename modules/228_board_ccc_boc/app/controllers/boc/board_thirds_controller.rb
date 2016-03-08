# -*- coding: utf-8 -*-
class Boc::BoardThirdsController < ApplicationController
  def index
    @table_a_open_by_service_desk = Icm::IncidentRequest.enabled.
        joins(",#{Icm::IncidentStatus.view_name} isv").
        select("isv.name status_name, SUM(1) amount, isv.display_color").
        where("isv.id = #{Icm::IncidentRequest.table_name}.incident_status_id").
        where("isv.language = 'zh'").
        where("DATE_FORMAT(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m') = ?", (Time.now).strftime('%Y-%m')). #当月事故单条件
    where("NOT EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id)").
        group("#{Icm::IncidentRequest.table_name}.incident_status_id").order("isv.display_sequence + 0 ASC").collect{|i| [i[:status_name], i[:amount].to_i, i[:display_color]]}
    # 事故单的分类柱状图
    @table_a_incident_by_category_open = Icm::IncidentRequest.enabled.joins(",#{Icm::IncidentSubCategory.view_name} ic").
        select("ic.name category_name, SUM(1) amount").
        where("ic.id = #{Icm::IncidentRequest.table_name}.incident_sub_category_id").
        where("ic.language = 'zh'").
        where("DATE_FORMAT(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m') = ?", (Time.now).strftime('%Y-%m')). #当月事故单条件
    where("NOT EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id)").
        group("#{Icm::IncidentRequest.table_name}.incident_sub_category_id").order("ic.code + 0 ASC").collect{|i| [i[:category_name], i[:amount].to_i, '']}
    # 事故单类型柱状图
    @table_a_incident_by_type_code = Icm::IncidentRequest.enabled.
        select("#{Icm::IncidentRequest.table_name}.request_type_code code_name, SUM(1) amount").
        where("DATE_FORMAT(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m') = ?", (Time.now).strftime('%Y-%m')). #当月事故单条件
    where("NOT EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id)").
        group("#{Icm::IncidentRequest.table_name}.request_type_code").order("#{Icm::IncidentRequest.table_name}.request_type_code + 0 ASC").collect{|i| [i[:code_name], i[:amount].to_i, '']}
    # 事故单优先级柱状图
    @table_a_incident_by_urgence = Icm::IncidentRequest.enabled.joins(",#{Icm::UrgenceCode.view_name} ic").
        select("ic.name urgence_name, SUM(1) amount").
        where("ic.id = #{Icm::IncidentRequest.table_name}.urgence_id").
        where("ic.language = 'zh'").
        where("DATE_FORMAT(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m') = ?", (Time.now).strftime('%Y-%m')). #当月事故单条件
    where("NOT EXISTS (SELECT 1 FROM icm_incident_journals ij WHERE ij.reply_type = 'CLOSE' AND ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id)").
        group("#{Icm::IncidentRequest.table_name}.urgence_id").order("ic.urgency_code + 0 ASC").collect{|i| [i[:urgence_name], i[:amount].to_i, '']}

    @table_a_incident_by_category_open.each do |c|
      c[2] = '#FF0900' if c[0].eql?("Failure")
      c[2] = '#E8AB5D' if c[0].eql?("Inquiry")
      c[2] = '#FFFEC7' if c[0].eql?("Change Request")
      c[2] = '#66D6FF' if c[0].eql?("Regular Maintenance")
      c[2] = '#84FF82' if c[0].eql?("Non-Regular Maintenance")
      c[2] = '#8E5DE8' if c[0].eql?("Master Maintenance")
      c[2] = '#A9E2E8' if c[0].eql?("EBS")
    end

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
