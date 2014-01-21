class Som::SendSummariesController < ApplicationController
  layout "application_full"

  def first_setting?
    flag=false
    @send_summary = Som::SendSummary.where(:person_id => Irm::Person.current.id).first
    @send_communicate = Som::SendCommunicate.where(:person_id => Irm::Person.current.id).first
    if @send_summary.nil?&&@send_communicate.nil?
      flag=true
    end
    flag
  end

  def setting
    if first_setting?
      @send_summary=Som::SendSummary.new
      @send_communicate=Som::SendCommunicate.new
    else
      @send_summary = Som::SendSummary.where(:person_id => Irm::Person.current.id).first
      @send_communicate = Som::SendCommunicate.where(:person_id => Irm::Person.current.id).first
    end
  end

  def update
    if first_setting?
      @send_summary = Som::SendSummary.new(params[:som_send_summary])
      @send_communicate = Som::SendCommunicate.new(params[:som_send_communicate])
      @send_summary.person_id=Irm::Person.current.id
      @send_communicate.person_id=Irm::Person.current.id
      respond_to do |format|
        if @send_summary.save&&@send_communicate.save
          format.html { redirect_to({:controller => "som/send_summaries", :action => "setting"}, :notice => t(:successfully_created)) }
          format.xml { render :xml => @send_summary, :status => :created, :location => @send_summary }
        else
          format.html { render :action => "setting" }
          format.xml { render :xml => @send_summary.errors, :status => :unprocessable_entity }
        end
      end
    else
      @send_summary = Som::SendSummary.where(:person_id => Irm::Person.current.id).first
      @send_communicate = Som::SendCommunicate.where(:person_id => Irm::Person.current.id).first
      respond_to do |format|
        if @send_summary.update_attributes(params[:som_send_summary])&&@send_communicate.update_attributes(params[:som_send_communicate])
          format.html { redirect_to({:controller => "som/send_summaries", :action => "setting"}, :notice => t(:successfully_updated)) }
          format.xml { head :ok }
        else
          format.html { render :action => "setting" }
          format.xml { render :xml => @send_summary.errors, :status => :unprocessable_entity }
        end
      end
    end
  end
end