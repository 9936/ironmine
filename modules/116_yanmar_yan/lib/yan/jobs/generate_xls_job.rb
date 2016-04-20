module Yan
  module Jobs
    class GenerateXlsJob<Struct.new(:p)
      def perform
        statis = Icm::IncidentRequest.
            select_all_for_reports.enabled.
            with_category(I18n.locale).
            with_close_reason(I18n.locale).
            with_requested_by(I18n.locale).
            with_incident_status(I18n.locale).
            with_support_group(I18n.locale).
            with_supporter(I18n.locale).
            with_priority(I18n.locale).
            with_urgence(I18n.locale).
            with_impact_range(I18n.locale).
            with_report_source(I18n.locale).
            with_external_system(I18n.locale).
            order("(#{Icm::IncidentRequest.table_name}.submitted_date) ASC")

        ex_attributes = []
        current_acc_systems = Irm::ExternalSystem.multilingual.order_with_name.with_person("000100012i8IyyjJaqMaJ6").enabled.collect(&:id)
        statis = statis.where("external_system.id IN (?)", current_acc_systems + [])
        if current_acc_systems.present? && current_acc_systems.size == 1
          ex_attributes = Irm::ObjectAttribute.multilingual.enabled.
              where("external_system_id = ?", current_acc_systems[0]).
              where("field_type = ?", "SYSTEM_CUX_FIELD").order("display_sequence ASC")
        end

        headers = [
            I18n.t(:label_icm_incident_request_request_number),
            I18n.t(:label_icm_incident_request_title),
            I18n.t(:label_icm_incident_request_summary),
            I18n.t(:label_irm_external_system),
            I18n.t(:label_icm_incident_request_requested_by),
            I18n.t(:label_icm_incident_request_support_person),
            I18n.t(:label_icm_incident_request_support_group),
            I18n.t(:label_icm_incident_request_priority),
            I18n.t(:label_icm_incident_request_incident_category),
            I18n.t(:label_icm_incident_request_incident_sub_category),
            I18n.t(:label_icm_incident_request_incident_status_code),
            I18n.t(:label_icm_incident_request_submitted_date),
            I18n.t(:label_icm_incident_request_estimated_date),
            I18n.t(:label_icm_incident_request_last_date),
            I18n.t(:label_icm_incident_journal_close_date),
            I18n.t(:label_icm_close_reason),
            I18n.t(:label_icm_urgency_name),
            I18n.t(:label_icm_impact_range),
            I18n.t(:label_icm_incident_request_report_source_code)
        ]

        ex_attributes.each do |ea|
          headers << ea[:name]
        end

        start_date = "1970-1-1"

        book = Spreadsheet::Workbook.new
        sheet1 = book.create_worksheet :name => 'Sheet1'
        sheet1.row(0).concat headers
        sheet1.row(0).height = 18
        format = Spreadsheet::Format.new :weight => :bold, :size => 10
        sheet1.row(0).default_format = format

        count = 1
        statis.each do |s|
          data = Array.new(19 + ex_attributes.size)
          data[0] = s[:request_number]
          data[1] = s[:title]
          data[2] = Irm::Sanitize.trans_html(Irm::Sanitize.sanitize(s[:summary],""))  unless s[:summary].nil?
          data[3] = s[:external_system_name]
          data[4] = s[:requested_name]
          data[5] = s[:supporter_name]
          data[6] = s[:support_group_name]
          data[7] = s[:priority_name]
          data[8] = s[:incident_category_name]
          data[9] = s[:incident_sub_category_name]
          data[10] = s[:incident_status_name]
          data[11] = s[:submitted_date].strptime("%F %T")
          data[12] = s[:estimated_date].strptime("%F %T")
          data[13] = s[:last_response_date].strptime("%F %T")
          # get close date
          last_close_journal = Icm::IncidentJournal.
              where("incident_request_id = ?", s.id).
              where("reply_type = ?", "CLOSE").
              select("created_at").
              order("created_at DESC").limit(1)
          if last_close_journal.any?
            data[14] = last_close_journal.first[:created_at]
            # (CloseDate is Null or CloseDate >= A)
            next if s.close? && Date.strptime("#{data[14]}", '%Y-%m-%d') < Date.strptime("#{start_date}", '%Y-%m-%d')
          else
            if s.close?
              data[14] = s[:last_response_date]
              next if Date.strptime("#{data[14]}", '%Y-%m-%d') < Date.strptime("#{start_date}", '%Y-%m-%d')
            else
              data[14] = ""
            end
          end
          data[15] = s[:close_reason_name]
          data[16] = s[:urgence_name]
          data[17] = s[:impact_range_name]
          data[18] = s[:report_source_name]
          nc = 19
          ex_attributes.each do |ea|
            data[nc] = s[ea[:attribute_name].to_sym]
            nc = nc + 1
          end
          sheet1.row(count).concat data
          count = count + 1
        end

        book.writer('public/reports/cux_ticket_detail_list.xls').write(book)
      end
    end
  end
end