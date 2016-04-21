module Yan::ReportsControllerEx
  def self.included(base)
    base.class_eval do
      def generate_xls
        @report = Irm::Report.find(params[:id])
        folder_id = @report.report_folder_id
        Delayed::Job.enqueue(Yan::Jobs::GenerateXlsJob.new())
        respond_to do |format|
          format.html { redirect_to({:action=>"index",:folder_id=>folder_id}) }
          format.xml  { head :ok }
        end
      end
      def download_xls
        send_data File.open("public/reports/cux_ticket_detail_list.xls","r").read, :filename=>"cux_ticket_detail_list.xls",:type => "application/vnd.openxmlformats"
      end
    end
  end
end