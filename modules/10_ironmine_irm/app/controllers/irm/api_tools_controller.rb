class Irm::ApiToolsController < ApplicationController
  layout "application_full"

  #api tools
  def index
    api_functions = Irm::Function.multilingual.api_functions
    @api_functions = api_functions.delete_if{|i| !Irm::Person.current.functions.include?(i.id) }
    permissions = Irm::Permission.with_rest_api.where(:function_id => @api_functions.map(&:id))

    @api_functions.each do |f|
      f[:rest_apis] ||= []
      permissions.each do |p|
        if p.function_id.eql?(f.id)
          f[:rest_apis] << p
        end
      end
    end
  end

  def console
    @api_base_url = request.base_url
  end

  #def get_data
  #  api_functions = Irm::Function.multilingual.api_functions
  #  api_functions = api_functions.delete_if{|i| !Irm::Person.current.functions.include?(i.id) }
  #
  #  permissions = Irm::Permission.with_rest_api.where(:function_id => api_functions.map(&:id))
  #  respond_to do |format|
  #    format.html {
  #      @count = permissions.count
  #      @datas = permissions
  #    }
  #  end
  #
  #end

  #获取对应API下的function
  def permission_data
    permission_scope = Irm::Permission.with_rest_api.query_by_function(params[:function_id])

    permissions = permission_scope.collect { |i| {:label => i[:name], :value => i[:api_id], :id => i[:api_id]} }
    respond_to do |format|
      format.json { render :json => permissions.to_grid_json([:label, :value], permissions.count) }
    end
  end

  #根据function中的id获取对应的参数
  def function_params
    #根据function_id获取对应的permission
    @api_params = Irm::ApiParam.query_input_params(params[:rest_api_id])
    @rest_api = Irm::RestApi.find(params[:rest_api_id])
    @permission = Irm::Permission.query_by_rest_api_id(params[:rest_api_id]).first
    @permission[:request_method] = @permission[:direct_get_flag].eql?('Y') ? "GET" : "POST"
  end

  #查看API对应permission的文档
  def doc
    #查找出所有的字段信息
    all_params = Irm::ApiParam.all_params(params[:rest_api_id])

    @input_params = []
    @output_params = []
    all_params.each do |p|
      if p[:param_classify].eql?("INPUT")
        @input_params << p
      elsif p[:param_classify].eql?("OUTPUT")
        @output_params << p
      else
        @input_params << p
        @output_params << p
      end
    end
  end

end
