class Irm::DemoController < ApplicationController
  def index
    respond_to do |format|
      format.html
    end
  end

  def get_data
    bulletin = Irm::Bulletin.search do
      keywords 'test'
#      keywords params[:content] if params[:content]
    end.results

    puts("+++++++++++++++" + bulletin.results.to_json)

    respond_to do |format|
      format.json  {render :json => to_jsonp(bulletin.results.to_grid_json([:id, :title,:published_date,:page_views,:author], 10)) }
    end
  end
end