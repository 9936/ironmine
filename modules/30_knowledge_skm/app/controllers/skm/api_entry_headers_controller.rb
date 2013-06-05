class Skm::ApiEntryHeadersController < ApplicationController
  def add

  end

  def show
    entry_header = Skm::EntryHeader.list_all.find(params[:id])

    #根据输出参数进行显示
    respond_to do |format|
      format.json { render json: entry_header.to_json(:only => [:id, :entry_title, :element_name,:entry_content],:include => [:entry_details]) }
    end
  end
end
