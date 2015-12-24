class Irm::HomeController < ApplicationController
  layout 'application_full'
  def index
  end

  def my_tasks
  end

  def kinds_of_count
    # 新建问题数
    # 如果是用户则只选择用户的系统项目
    if Irm::Person.current.profile.user_license.eql?("SUPPORTER")
      span_1 = Icm::IncidentRequest.where(:incident_status_id=>"000K000A0gG4yyDU3KUO1o").length
    else
      span_1 = Icm::IncidentRequest.where(:incident_status_id=>"000K000A0gG4yyDU3KUO1o").filter_system_ids(Irm::Person.current.system_ids).length
    end

    # 如果是用户则只选择用户的系统项目
    # 处理中的问题数
    span_2 = Icm::IncidentRequest.where(:support_person_id=>Irm::Person.current.id).without_closed.length
    # 我参与的问题数
    span_3 = Icm::IncidentRequest.mine_filter.without_closed.length

    render json: {:span_1=>span_1.to_s,:span_2=>span_2.to_s,:span_3=>span_3.to_s}
  end
end