class Irm::ApiPeopleController < ApiController
  #查看用户
  #Request: /api_peoples/show.json
  def show
    person = Irm::Person.list_all.where("#{Irm::Person.table_name}.id=? OR #{Irm::Person.table_name}.login_name=?", params[:id], params[:id]).first
    if person.present?
      #根据输出参数进行显示
      respond_to do |format|
        format.json {
          render json: person.to_json(:only => @return_columns)
        }
      end
    else
      raise "user:#{params[:id]} not exist."
    end
  end
end
