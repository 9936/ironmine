class Irm::DemoController < ApplicationController
  def index
    @bulletin = Irm::Bulletin.search do
      keywords "3"
    end.results
  end
end