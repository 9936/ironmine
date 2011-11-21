# -*-coding: utf-8 -*-
class Irm::DemoController < ApplicationController
  def index
    respond_to do |format|
      format.html
    end
  end

  def get_data
#    bulletin = Irm::Bulletin.search do
#      keywords '测试'
##      keywords params[:content] if params[:content]
#    end.results

    bulletin = Sunspot.search Irm::Bulletin do
                keywords params[:title] do
                  highlight :title
                end
                paginate :page => params[:page] ? params[:page] : 1, :per_page => params[:limit] ? params[:limit] : 10
              end.results
    puts("+++++++++++++++" + bulletin.to_json)
    respond_to do |format|
      format.json  {render :json => to_jsonp(bulletin.to_grid_json([:id, :title,:published_date,:page_views,:author], 10)) }
    end
  end
end