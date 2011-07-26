class Irm::ReportFoldersController < ApplicationController
  # GET /report_folders
  # GET /report_folders.xml
  def index
    redirect_to({:controller => "irm/reports",:action => "index"})
  end


  # GET /report_folders/new
  # GET /report_folders/new.xml
  def new
    @report_folder = Irm::ReportFolder.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @report_folder }
    end
  end

  # GET /report_folders/1/edit
  def edit
    @report_folder = Irm::ReportFolder.multilingual.find(params[:id])
  end

  # POST /report_folders
  # POST /report_folders.xml
  def create
    @report_folder = Irm::ReportFolder.new(params[:irm_report_folder])

    respond_to do |format|
      if @report_folder.valid?
        @report_folder.create_member_from_str
        @report_folder.save
        format.html { redirect_to({:controller => "irm/reports",:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @report_folder, :status => :created, :location => @report_folder }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @report_folder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /report_folders/1
  # PUT /report_folders/1.xml
  def update
    @report_folder = Irm::ReportFolder.multilingual.find(params[:id])

    respond_to do |format|
      if @report_folder.update_attributes(params[:irm_report_folder])
        format.html { redirect_to({:controller => "irm/reports",:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @report_folder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /report_folders/1
  # DELETE /report_folders/1.xml
  def destroy
    @report_folder = Irm::ReportFolder.find(params[:id])
    @report_folder.destroy

    respond_to do |format|
      format.html { redirect_to(report_folders_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @report_folder = Irm::ReportFolder.find(params[:id])
  end

  def multilingual_update
    @report_folder = Irm::ReportFolder.find(params[:id])
    @report_folder.not_auto_mult=true
    respond_to do |format|
      if @report_folder.update_attributes(params[:irm_report_folder])
        format.html { redirect_to({:controller => "irm/reports",:action => "show"}, :notice => 'Report folder was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "multilingual_edit" }
        format.xml  { render :xml => @report_folder.errors, :status => :unprocessable_entity }
      end
    end
  end

end
