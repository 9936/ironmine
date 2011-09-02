class Irm::MyProfilesController < ApplicationController
  #个人信息显示页面
  def index
    @profile = Irm::Profile.multilingual.with_kanban.find(Irm::Person.current.profile.id)
  end

end
