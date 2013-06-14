class Emw::ErrorTablesController < ApplicationController
  layout "application_full"

  def show
    @error_table = Emw::ErrorTable.find(params[:id])
  end

  def new
    @error_table = Emw::ErrorTable.new
  end

  def create
    @error_table = Emw::ErrorTable.new(params[:emw_error_table])
    @error_table.interface_table_id = params[:table_id]

    @error_table.save
  end

  def edit
    @error_table = Emw::ErrorTable.find(params[:id])
  end

  def update
    @error_table = Emw::ErrorTable.find(params[:id])

    respond_to do |format|
      if @error_table.update_attributes(params[:emw_error_table])
        format.html { redirect_to({:controller => "emw/interfaces",:action => "show", :id => @error_table.interface_table.interface_id }, :notice => t(:successfully_updated)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

end