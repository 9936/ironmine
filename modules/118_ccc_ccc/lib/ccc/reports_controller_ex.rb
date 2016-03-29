module Ccc::ReportsControllerEx
  def self.included(base)
    base.class_eval do
      def run
        start_time = Time.now

        folder_ids = Irm::Person.current.report_folders.collect{|i| i.id}
        @report = Irm::Report.multilingual.query_by_folders(folder_ids).with_report_type(I18n.locale).with_report_folder(I18n.locale).filter_by_folder_access(Irm::Person.current.id).find(params[:id])

        if "CUSTOM".eql?(@report.program_type)
          @report.attributes =  params[:irm_report]
        end

        if params[:apply].present?
          if @report.filter_date_range_type.present? and !@report.filter_date_range_type.to_s.eql?('CUSTOM')
            @report.filter_date_from = nil
            @report.filter_date_to = nil
          end
          @report.save
        end

        @report.program_params = params[:program_params]||{}

        @filter_date_from=""
        @filter_date_to=""

        if @report.filter_date_range_type.present? and !@report.filter_date_range_type.to_s.eql?('CUSTOM')
          from_and_to = Irm::ConvertTime.convert(@report.filter_date_range_type)
          @filter_date_from = @report.filter_date_from = from_and_to[:from]
          @filter_date_to = @report.filter_date_to = from_and_to[:to]
        else
          @filter_date_from = @report.filter_date_from.strftime("%Y-%m-%d") if @report.filter_date_from.present?
          @filter_date_to = @report.filter_date_to.strftime("%Y-%m-%d") if @report.filter_date_to.present?
        end

        respond_to do |format|
          format.html { render(:action=>"show", :layout => "report_application_full") }
          format.xls  { send_data(export_report_data_to_excel(@report),:type => "text/plain", :filename=>"report_#{@report.code.downcase}_#{Time.now.strftime('%Y%m%d%H%M%S')}.xls") }
          format.pdf  {
            render :pdf => @report[:name],
                   :print_media_type => true,
                   :encoding => 'utf-8',
                   :page_size => 'A4',
                   #:book => true,
                   #:show_as_html => true,
                   :zoom => 0.8
          }
        end

        end_time = Time.now

        #记录报表运行历史
        report_params = @report.program_params.merge({:date_from=>@filter_date_from,:date_to=>@filter_date_to})
        report_history = Irm::ReportRequestHistory.create(:report_id=>@report.id,:executed_by=>Irm::Person.current.id,:start_at=>start_time,:end_at=>end_time,:execute_type=>"PAGE",:params=>report_params)
        @report.current_history_id = report_history.id
      end

      def new_template
        @report = Irm::Report.new(:program_type=>"TEMPLATE")
        respond_to do |format|
          format.html { render :layout => "report_application_full"}# index.html.erb
        end
      end

      def create_template
        #@report = Irm::Report.new(params[:irm_report])
        temp_uniq_id = UUID.generate(:compact)[0, 21]
        template = Irm::AttachmentVersion.create_single_version_file(params[:report_template],
                                                          "",
                                                          Irm::LookupValue.get_code_id("SKM_FILE_CATEGORIES", "DOCUMENT"),
                                                          Irm::Report.name,
                                                          temp_uniq_id)
        respond_to do |format|
          if template
            fullpath = Rails.root.to_s + "/public/" + template.path.to_s + template.source_file_name
            Delayed::Job.enqueue(Irm::Jobs::RunTemplateReportJob.new(fullpath.to_s, Irm::Person.current.id, template.id, Time.now().strftime("%F %T")), 0,Time.now)
            #template.update_attribute(:source_id, @report.id)
            format.html { redirect_to({:action=>"show_template"}, :notice => t(:successfully_created)) }
          else
            format.html { render :action => "new_template" }
          end
        end
      end

      def edit_template
        @report = Irm::Report.multilingual.find(params[:id])
      end

      def update_template
        @report = Irm::Report.find(params[:id])
        if params[:report_template]
          old_template = Irm::AttachmentVersion.find(@report.attachment_version_id)
          temp_uniq_id = UUID.generate(:compact)[0, 21]
          template = Irm::AttachmentVersion.create_single_version_file(params[:report_template],
                                                            "",
                                                            Irm::LookupValue.get_code_id("SKM_FILE_CATEGORIES", "DOCUMENT"),
                                                            Irm::Report.name,
                                                            temp_uniq_id)
          @report.attachment_version_id = template.id
        end
        respond_to do |format|
          if @report.update_attributes(params[:irm_report])
            template.update_attribute(:source_id, @report.id) if params[:report_template]
            old_template.attachment.destroy if params[:report_template]
            format.html { redirect_to({:action=>"show",:id=>@report.id}, :notice => t(:successfully_created)) }
          else
            format.html { render({:action=>"edit",:id=>@report.id}, :layout => "report_application_full") }
          end
        end
      end
    end
  end
end