class Irm::ApiToolsController < ApplicationController
  layout "application_full"

  #api tools
  def index
    @api_base_url = request.base_url
  end

  #获取对应API下的function
  def function_data
    function_scope = Irm::Function.multilingual.query_by_function_group(params[:function_group_id])

    functions = function_scope.collect { |i| {:label => i[:name], :value => i.id, :id => i.id} }
    respond_to do |format|
      format.json { render :json => functions.to_grid_json([:label, :value], functions.count) }
    end
  end

  #根据function中的id获取对应的参数
  def function_params
    #根据function_id获取对应的permission
    @api_params = []
    @permission = Irm::Permission.query_by_function_id(params[:function_id]).first
    if @permission.present?
      @api_params = Irm::ApiParam.with_permission_by_function(params[:function_id])
      @permission[:request_method] = @permission[:direct_get_flag].eql?('Y') ? "GET" : "POST"
    end

  end

  #查看API对应permission的文档
  def doc
    #
  end

end
