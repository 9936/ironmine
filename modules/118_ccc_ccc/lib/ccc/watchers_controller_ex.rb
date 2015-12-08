module Ccc::WatchersControllerEx
  def self.included(base)
    base.class_eval do
      def add_watcher
        @watchable = eval(params[:watchable_type]).find(params[:watchable_id])
        watcher = Irm::Person.find(params[:watcher])
        @watchable.add_watcher(watcher)
        @watchable.save
        @sid = params[:sid] if params[:sid]
        if params[:watchable_type].eql?(Icm::IncidentRequest.name)
          Icm::IncidentHistory.create({:request_id => params[:watchable_id],
                                       :journal_id=> "",
                                       :property_key=> "add_watcher",
                                       :old_value=>params[:watcher],
                                       :new_value=> ""})
          incident_request = Icm::IncidentRequest.find(params[:watchable_id])
          incident_request.update_attribute(:attribute5,watcher.email_address)
          # 事故单添加跟踪者发送邮件
          # Delayed::Job.enqueue(Irm::Jobs::ActionProcessJob.new({:bo_id => params[:watchable_id], :bo_code => "ICM_INCIDENT_REQUESTS", :action_id => "002i000C2jUfvOMmSeX1ZQ", :action_type => "Irm::WfMailAlert"}))
          # Delayed::Job.enqueue(Ccc::Jobs::IncidentSendEmailsTaskJob.new(params[:watchable_id],"ICM_INCIDENT_REQUESTS","002i000C2jUfvOMmSeX1ZQ","Irm::WfMailAlert"))
          options = {:bo_id => params[:watchable_id], :bo_code => "ICM_INCIDENT_REQUESTS", :action_id => "002i000C2jUfvOMmSeX1ZQ", :action_type => "Irm::WfMailAlert"}
          Delayed::Job.enqueue(Irm::Jobs::ActionProcessJob.new(options))
        end
    #    prepare_order
        @editable = params[:editable]
        @dom_id = params[:_dom_id]

        respond_to do |format|
          format.js {render :add_watcher}
        end
      end
    end
  end
end