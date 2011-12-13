class Chm::ChangeJournalsController < ApplicationController

  # GET /statuses/new
  # GET /statuses/new.xml
  def new
    @change_journal = Chm::ChangeJournal.new(params[:chm_change_journal])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @change_impact }
    end
  end

  # GET /statuses/1/edit
  def edit
    @change_impact = Chm::ChangeImpact.multilingual.find(params[:id])
  end

  # POST /statuses
  # POST /statuses.xml
  def create
    @change_journal = Chm::ChangeJournal.new(params[:chm_change_journal])
    @success = false
    respond_to do |format|
      if @change_journal.save
        process_files(@change_journal)
        @change_journal_show =  Chm::ChangeJournal.list_all.find(@change_journal.id)
        @change_journal = Chm::ChangeJournal.new(:change_request_id=>@change_journal.change_request_id,:replied_by=>Irm::Person.current.id)
        @request_files = Chm::ChangeRequest.request_files(@change_journal_show.change_request_id)
        @change_request = @change_journal_show.change_request
        @success = true
        format.html {
          responds_to_parent do
            render :layout=>"xhr"
          end
        }
        format.xml  { render :xml => @cange_journal, :status => :created, :location => @change_journal }
      else
         ormat.html {
          responds_to_parent do
            render :layout=>"xhr"
          end
        }
        format.xml  { render :xml => @cange_journal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /statuses/1
  # PUT /statuses/1.xml
  def update
    @change_impact = Chm::ChangeImpact.find(params[:id])

    respond_to do |format|
      if @change_impact.update_attributes(params[:chm_change_impact])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @change_impact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.xml
  def destroy
    @change_impact = Chm::ChangeImpact.find(params[:id])
    @change_impact.destroy

    respond_to do |format|
      format.html { redirect_to(statuses_url) }
      format.xml  { head :ok }
    end
  end


  private
  def process_files(ref_journal)
    @files = []
    params[:files].each do |key,value|
      @files << Irm::AttachmentVersion.create({:source_id=>ref_journal.id,
                                               :source_type=>ref_journal.class.name,
                                               :data=>value[:file],
                                               :description=>value[:description]}) if(value[:file]&&!value[:file].blank?)
    end if params[:files]

  end

end
