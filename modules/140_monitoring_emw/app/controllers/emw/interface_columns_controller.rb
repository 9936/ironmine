class Emw::InterfaceColumnsController < ApplicationController
  layout "application_full"

  def show
    @interface_column = Emw::InterfaceColumn.find(params[:id])
  end

  def new
    @interface_column = Emw::InterfaceColumn.new
  end

  def create
    @interface_column = Emw::InterfaceColumn.new(params[:emw_interface_column])
    @interface_column.interface_table_id = params[:table_id]

    @interface_column.save
  end

  def edit
    @interface_column = Emw::InterfaceColumn.find(params[:id])
  end

  def update
    @interface_column = Emw::InterfaceColumn.find(params[:id])
    @interface_column.update_attributes(params[:emw_interface_column])
  end

  def destroy
    @interface_column = Emw::InterfaceColumn.find(params[:id])
    @interface_column.destroy
    respond_to do |format|
      format.html { redirect_to({:controller => "emw/interfaces",:action => "show", :id => @interface_column.interface_table.interface_id }) }
    end
  end

end