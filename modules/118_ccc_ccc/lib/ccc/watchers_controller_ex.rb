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
          # 事故单添加跟踪者发送邮件
          puts "11111111"
          puts watcher.email_address
          Delayed::Job.enqueue(Ccc::Jobs::IncidentSendEmailsTaskJob.new("ADD_WATCHER",watcher.email_address,params[:watchable_id]))
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