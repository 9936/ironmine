class Icm::MailRequestsController < ApplicationController
  def index

  end

  def get_data
    mail_requests_scope = Icm::MailRequest.list_all
#    mail_requests_scope = mail_requests_scope.match_value("#{Icm::ImpactRange.table_name}.impact_code",params[:impact_code])
#    mail_requests_scope = mail_requests_scope.match_value("#{Icm::ImpactRangesTl.table_name}.name",params[:name])
#    mail_requests_scope = mail_requests_scope.match_value("#{Icm::ImpactRange.table_name}.default_flag",params[:default_flag])
    mail_requests, count = paginate(mail_requests_scope)

    respond_to do |format|
      format.json  {render :json => to_jsonp(mail_requests.to_grid_json([:username,:external_system_name,
                                                                         :service_name,:support_group_name,
                                                                         :supporter_name,:impact_range_name,
                                                                         :urgency_name,:status_code], count)) }
    end
  end

  def new
    @mail_request = Icm::MailRequest.new
  end

  def create
    @mail_request = Icm::MailRequest.new(params[:icm_mail_request])
    respond_to do |format|
      if @mail_request.save
        format.html{redirect_to({:action => "index"})}
      else
        format.html { render :action => "new" }
      end
    end
  end

  def edit
    @mail_request = Icm::MailRequest.find(params[:id])
  end

  def update
    @mail_request = Icm::MailRequest.find(params[:id])

    respond_to do |format|
      if @mail_request.update_attributes(params[:icm_mail_request])
        format.html { redirect_to({:action=>"index"}, :notice => t(:successfully_updated)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
end