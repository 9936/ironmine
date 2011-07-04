class Irm::DemoController < ApplicationController
  def index
    puts("+++++++++++++++" + request.remote_ip)
  end
end