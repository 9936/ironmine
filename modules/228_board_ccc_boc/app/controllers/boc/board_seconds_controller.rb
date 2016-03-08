# -*- coding: utf-8 -*-
class Boc::BoardSecondsController < ApplicationController
  def index
    # 新建的事故单
    @count_new = Icm::IncidentRequest.
        joins("LEFT OUTER JOIN #{Icm::IncidentCategory.view_name} ic ON ic.id = #{Icm::IncidentRequest.table_name}.incident_category_id AND ic.language = 'zh'").
        enabled.
        select("#{Icm::IncidentRequest.table_name}.request_number request_number, ic.name category_name").
        joins(",#{Icm::IncidentStatus.table_name} iis").
        # where("#{Icm::IncidentRequest.table_name}.hotline = ?", 'Y').
        where("DATE_FORMAT(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m-%d') = ?", (Time.now).strftime('%Y-%m-%d')).
        where("#{Icm::IncidentRequest.table_name}.external_system_id IS NOT NULL").
        where("#{Icm::IncidentRequest.table_name}.external_system_id <> '--- Please Select ---'").
        where("iis.id = #{Icm::IncidentRequest.table_name}.incident_status_id").
        where("iis.id = '000K000A0gG4yyDU3KUO1o'").
        order("#{Icm::IncidentRequest.table_name}.created_at DESC")
    # 已分配的事故单(待处理)
    @count_assign = Icm::IncidentRequest.
        joins("LEFT OUTER JOIN #{Icm::IncidentCategory.view_name} ic ON ic.id = #{Icm::IncidentRequest.table_name}.incident_category_id AND ic.language = 'zh'").
        enabled.
        select("#{Icm::IncidentRequest.table_name}.request_number request_number, ic.name category_name").
        joins(",#{Icm::IncidentStatus.table_name} iis").
        where("DATE_FORMAT(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m-%d') = ?", (Time.now).strftime('%Y-%m-%d')).
        where("#{Icm::IncidentRequest.table_name}.external_system_id IS NOT NULL").
        where("#{Icm::IncidentRequest.table_name}.external_system_id <> '--- Please Select ---'").
        where("iis.id = #{Icm::IncidentRequest.table_name}.incident_status_id").
        where("iis.id = '000K000922scMSu1Q8vthI'").
        order("#{Icm::IncidentRequest.table_name}.created_at DESC")
    # 处理中的事故单
    @count_solving = Icm::IncidentRequest.
        joins("LEFT OUTER JOIN #{Icm::IncidentCategory.view_name} ic ON ic.id = #{Icm::IncidentRequest.table_name}.incident_category_id AND ic.language = 'zh'").
        enabled.
        select("#{Icm::IncidentRequest.table_name}.request_number request_number, ic.name category_name").
        joins(",#{Icm::IncidentStatus.table_name} iis").
        where("DATE_FORMAT(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m-%d') = ?", (Time.now).strftime('%Y-%m-%d')).
        where("#{Icm::IncidentRequest.table_name}.external_system_id IS NOT NULL").
        where("#{Icm::IncidentRequest.table_name}.external_system_id <> '--- Please Select ---'").
        where("iis.id = #{Icm::IncidentRequest.table_name}.incident_status_id").
        where("iis.id not in ('000K000922scMSu1Q8vthI','000K000922scMSu1QUxWoy','000K000A0gG4yyDU3KUO1o','000K000A0g9LO0pOKPsZ1s')").
        order("#{Icm::IncidentRequest.table_name}.created_at DESC")
    # 已完成的事故单
    @count_close = Icm::IncidentRequest.
        joins("LEFT OUTER JOIN #{Icm::IncidentCategory.view_name} ic ON ic.id = #{Icm::IncidentRequest.table_name}.incident_category_id AND ic.language = 'zh'").
        enabled.
        select("#{Icm::IncidentRequest.table_name}.request_number request_number, ic.name category_name").
        joins(",#{Icm::IncidentStatus.table_name} iis").
        where("DATE_FORMAT(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m-%d') = ?", (Time.now).strftime('%Y-%m-%d')).
        where("#{Icm::IncidentRequest.table_name}.external_system_id IS NOT NULL").
        where("#{Icm::IncidentRequest.table_name}.external_system_id <> '--- Please Select ---'").
        where("iis.id = #{Icm::IncidentRequest.table_name}.incident_status_id").
        where("iis.id in ('000K000922scMSu1QUxWoy','000K000A0g9LO0pOKPsZ1s')").
        order("#{Icm::IncidentRequest.table_name}.created_at DESC")

    # 当日高紧急度问题
    @high_new = Icm::IncidentRequest.enabled.where("#{Icm::IncidentRequest.table_name}.urgence_id = '000R000B2jQm9tAWaRMGtE'").
        where("DATE_FORMAT(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m-%d') = ?", (Time.now).strftime('%Y-%m-%d'))
    # 当日紧急问题
    @urgence_new = Icm::IncidentRequest.enabled.where("#{Icm::IncidentRequest.table_name}.urgence_id = '000R000B2jQm9tAWaFlqQi'").
        where("DATE_FORMAT(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m-%d') = ?", (Time.now).strftime('%Y-%m-%d'))

    @high_urgence_today = Icm::IncidentRequest.
        joins("LEFT OUTER JOIN #{Icm::IncidentStatus.view_name} incident_status ON  incident_status.id = #{Icm::IncidentRequest.table_name}.incident_status_id AND incident_status.language= 'zh'").
        joins("LEFT OUTER JOIN #{Icm::UrgenceCode.view_name} urgence_code ON  urgence_code.id = #{Icm::IncidentRequest.table_name}.urgence_id AND urgence_code.language = 'zh'").
        joins("LEFT OUTER JOIN irm_people supporter ON  supporter.id = #{Icm::IncidentRequest.table_name}.support_person_id").
        joins("LEFT OUTER JOIN #{Irm::Organization.view_name} iov ON iov.id = #{Icm::IncidentRequest.table_name}.organization_id AND iov.language = 'zh'").
        enabled.
        select("incident_status.name incident_status_name,#{Icm::IncidentRequest.table_name}.request_number request_number, #{Icm::IncidentRequest.table_name}.title title,urgence_code.name urgence_name,supporter.full_name supporter_name,#{Icm::IncidentRequest.table_name}.submitted_date submitted_date,iov.name organization_name").
        joins(",#{Icm::IncidentStatus.table_name} iis").
        where("DATE_FORMAT(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m-%d') = ?", (Time.now).strftime('%Y-%m-%d')).
        where("#{Icm::IncidentRequest.table_name}.external_system_id IS NOT NULL").
        where("#{Icm::IncidentRequest.table_name}.external_system_id <> '--- Please Select ---'").
        where("iis.id = #{Icm::IncidentRequest.table_name}.incident_status_id").
        where("#{Icm::IncidentRequest.table_name}.urgence_id in ('000R000B2jQm9tAWaFlqQi','000R000B2jQm9tAWaRMGtE')").
        order("urgence_code.name ASC").
        collect{|a|
      {
          :request_number=>a[:request_number],
          :title=>a[:title],
          :urgence_name=>a[:urgence_name],
          :supporter_name=>a[:supporter_name],
          :submitted_date=>a[:submitted_date],
          :organization_name=>a[:organization_name],
          :incident_status_name=>a[:incident_status_name]
      }
    }

    @sla_list = []
    @sla_list = Icm::IncidentRequest.
        joins("LEFT OUTER JOIN ccc_sla_con_incidents sci on icm_incident_requests.id = sci.incident_request_id").
        joins("LEFT OUTER JOIN irm_people supporter ON  supporter.id = sci.supporter_id").
        joins("LEFT OUTER JOIN slm_sla_instances ssi ON ssi.id = sci.sla_instance_id").
        joins("LEFT OUTER JOIN #{Irm::Organization.view_name} iov ON iov.id = #{Icm::IncidentRequest.table_name}.organization_id AND iov.language = 'zh'").
        select("#{Icm::IncidentRequest.table_name}.request_number request_number,#{Icm::IncidentRequest.table_name}.request_type_code type_name,#{Icm::IncidentRequest.table_name}.title title,supporter.full_name supporter_name,#{Icm::IncidentRequest.table_name}.submitted_date submitted_date,iov.name organization_name,sci.service_name service_name").
        enabled.
        group("sci.incident_request_id").
        where("ssi.current_status = 'START'").
        where("#{Icm::IncidentRequest.table_name}.incident_status_id not in ('000K000A0g9LO0pOKPsZ1s','000K000922scMSu1QUxWoy')").
        where("sci.type_name = '超时'").
        collect{|a|
      service_name = ""
      if a[:service_name].index("新建").present?
        service_name = "分配超时"
      elsif a[:service_name].index("分配").present? && a[:service_name].index("处理中").present?
        service_name = "开始处理超时"
      elsif a[:service_name].index("处理中").present? && !a[:service_name].index("分配").present?
        service_name = "进度更新超时"
      elsif a[:service_name].index("总").present?
        service_name = "总处理时间超时"
      end
      if service_name.eql?("总处理时间超时") && a[:type_name].eql?("新增需求")
        next
      end
      {
          :request_number=>a[:request_number],
          :title=>a[:title],
          :supporter_name=>a[:supporter_name],
          :submitted_date=>a[:submitted_date],
          :organization_name=>a[:organization_name],
          :service_name=>service_name
      }
    }
    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end
end
