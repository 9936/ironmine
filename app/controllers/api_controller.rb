class ApiController < ApplicationController
  before_filter :set_return_columns
  around_filter :set_access_history

  private
  def set_access_history
    access_history = Irm::OauthAccessHistory.new({:client_id => session[:client_id] || "api_tool",
                                                  :access_by => Irm::Person.current.id,
                                                  :accessed_at => Time.zone.now,
                                                  :access_ip => request.remote_ip,
                                                  :access_params => params.to_hash.to_s})
    #根据controller和action查找出对应API的名称
    rest_api = Irm::RestApi.query_by_controller_action(params[:controller], params[:action]).first
    access_history.access_api = rest_api[:name] if rest_api.present?
    begin
      yield
      access_history.success_flag = 'Y'
    rescue Exception => e
      access_history.success_flag = 'N'
      access_history.error_message =e.message
      respond_to do |format|
        format.json {
          render :json => {:error_info => e.message}
        }
      end

    end
    access_history.save
  end

  def set_return_columns
    @return_columns = []
    output_params = Irm::ApiParam.get_output_params(params[:controller], params[:action])
    output_params.each do |p|
      @return_columns << p.name.to_sym
    end
    @return_columns
  end


end