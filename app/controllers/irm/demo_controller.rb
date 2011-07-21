class Irm::DemoController < ApplicationController
  def index
    @kanban = Irm::Kanban.find(1)
  end
end