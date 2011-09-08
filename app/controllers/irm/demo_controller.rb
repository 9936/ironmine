class Irm::DemoController < ApplicationController
  def index
  end

  def get_data
    @bulletin = Irm::Bulletin.search do
      keywords params[:title] if params[:title]
      keywords params[:content] if params[:content]
    end.results

    respond_to do |format|
      format.json {render :json=>to_jsonp(@bulletin.to_grid_json([:title,:content,:page_views,:published_date], 10))}
    end
  end
end