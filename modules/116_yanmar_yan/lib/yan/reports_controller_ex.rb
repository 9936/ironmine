module Yan::ReportsControllerEx
  def self.included(base)
    base.class_eval do
      def generate_xls
        @report = Irm::Report.find(params[:id])
        Delayed::Job.enqueue(Yan::Jobs::GenerateXlsJob.new())
        respond_to do |format|
          format.html { render :action => "show", :layout => "application_full" }
          format.xml  { render :xml => @report }
        end
      end
    end
  end
end