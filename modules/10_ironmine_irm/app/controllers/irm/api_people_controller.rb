class Irm::ApiPeopleController < ApplicationController
  before_filter :set_return_columns

  #查看用户
  #Request: /api_peoples/show.json
  def show
    person = Irm::Person.list_all.where("#{Irm::Person.table_name}.id=? OR #{Irm::Person.table_name}.login_name=?", params[:id], params[:id]).first
    #根据输出参数进行显示
    respond_to do |format|
      format.json {
        render json: person.to_json(:only => @return_columns)
      }
    end
  end

  private

    def set_return_columns
      @return_columns = []
      output_params = Irm::ApiParam.get_output_params(params[:controller], params[:action])
      output_params.each do |p|
        @return_columns << p.name.to_sym
      end
      @return_columns
    end
end
