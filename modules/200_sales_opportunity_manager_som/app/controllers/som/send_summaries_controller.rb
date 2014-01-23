class Som::SendSummariesController < ApplicationController
  layout "application_full"


  def new
    @sales_summary_notify = Som::SendSummary.sales_summary_notify
    @sales_communicate_notify = Som::SendSummary.sales_communicate_notify
    @sales_opportunity_notify = Som::SendSummary.sales_opportunity_notify
  end

  def create
    @sales_summary_notify = Som::SendSummary.sales_summary_notify
    @sales_communicate_notify = Som::SendSummary.sales_communicate_notify
    @sales_opportunity_notify = Som::SendSummary.sales_opportunity_notify
    current_person_id=Irm::Person.current.id
    @sales_summary_notify.attributes = params[:som_send_summary]
    @sales_communicate_notify.attributes = params[:som_send_communicate]
    @sales_opportunity_notify.attributes = params[:som_send_opportunity]
    @sales_summary_notify.person_id = current_person_id
    @sales_communicate_notify.person_id = current_person_id
    @sales_opportunity_notify.person_id = current_person_id

    respond_to do |format|
      if @sales_summary_notify.save&&@sales_communicate_notify.save&&@sales_opportunity_notify.save
        format.html { redirect_to({:controller => "som/send_summaries", :action => "new"}, :notice => t(:successfully_created)) }
        format.xml { render :xml => @send_summary, :status => :created, :location => @send_summary }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @send_summary.errors, :status => :unprocessable_entity }
      end
    end
  end
end