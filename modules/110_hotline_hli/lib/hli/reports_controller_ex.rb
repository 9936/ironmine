module Hli::ReportsControllerEx
  def self.included(base)
    base.class_eval do
      def new_template
        @report = Irm::Report.new(:program_type=>"TEMPLATE")
        respond_to do |format|
          format.html { render :layout => "application_full"}# index.html.erb
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
            format.html { render({:action=>"edit",:id=>@report.id}, :layout => "application_full") }
          end
        end
      end
    end
  end
end