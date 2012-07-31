class Chm::ChangePlansController < ApplicationController

  # GET /statuses/new
  # GET /statuses/new.xml
  def change

    @change_request = Chm::ChangeRequest.list_all.find(params[:change_request_id])

    @change_plan_types = Chm::ChangePlanType.multilingual.enabled

    @grouped_change_plans={}

    change_plans =  @change_request.change_plans.list_all

    @change_plan_types.each do |change_plan_type|
      change_plan = change_plans.detect{|i| i.change_plan_type_id.eql?(change_plan_type.id)}
      change_plan = Chm::ChangePlan.new(:planed_by=>Irm::Person.current.id,:change_plan_type_id=>change_plan_type.id,:change_request_id=>@change_request.id) unless change_plan.present?
      @grouped_change_plans[change_plan_type.id] = change_plan
    end

    @current_change_plan_type_id = params[:change_plan_type_id]

    respond_to do |format|
      format.js
      format.xml  { render :xml => @change_plan }
    end
  end

  # POST /statuses
  # POST /statuses.xml
  def create
    @change_plan = Chm::ChangePlan.new(params[:chm_change_plan])

    @change_plan_type = Chm::ChangePlanType.multilingual.find(@change_plan.change_plan_type_id)

    respond_to do |format|
      if @change_plan.save
        process_files(@change_plan)
        @change_plan = Chm::ChangePlan.list_all.find(@change_plan.id)
        format.html {
          responds_to_parent do
            render :layout=>"xhr"
          end
        }
        format.xml  { render :xml => @change_plan, :status => :created, :location => @change_plan }
      else
        format.html {
          @change_request = @change_plan.change_request
          responds_to_parent do
            render :layout=>"xhr"
          end
        }
        format.xml  { render :xml => @change_plan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /statuses/1
  # PUT /statuses/1.xml
  def update
    @change_plan = Chm::ChangePlan.find(params[:id])

    @change_plan.attributes = params[:chm_change_plan]

    @change_plan_type = Chm::ChangePlanType.multilingual.find(@change_plan.change_plan_type_id)

    @success = false

    respond_to do |format|
      if @change_plan.save
        @success = true
        process_files(@change_plan)
        @change_plan = Chm::ChangePlan.list_all.find(@change_plan.id)
        format.html {
          responds_to_parent do
            render :layout=>"xhr"
          end
        }
        format.xml  { render :xml => @change_plan, :status => :created, :location => @change_plan }
      else
        format.html {
          @change_request = @change_plan.change_request
          responds_to_parent do
            render :layout=>"xhr"
          end
        }
        format.xml  { render :xml => @change_plan.errors, :status => :unprocessable_entity }
      end
    end
  end

  def refresh
    @change_request = Chm::ChangeRequest.list_all.find(params[:change_request_id])

    @change_plan_types = Chm::ChangePlanType.multilingual.enabled

    @grouped_change_plans={}

    @change_plan_types.each do |change_plan_type|
      change_plan = @change_request.change_plans.detect{|i| i.change_plan_type_id.eql?(change_plan_type.id)}
      change_plan = Chm::ChangePlan.new(:change_plan_type_id=>change_plan_type.id,:change_request_id=>@change_request.id) unless change_plan.present?
      @grouped_change_plans[change_plan_type.id] = change_plan
    end

     respond_to do |format|
      format.js
      format.xml  { render :xml => @change_plan }
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
  def process_files(change_plan)
    @files = []
    params[:files].each do |key,value|
      @files << Irm::AttachmentVersion.create({:source_id=>change_plan.id,
                                               :source_type=>change_plan.class.name,
                                               :data=>value[:file],
                                               :description=>value[:description]}) if(value[:file]&&!value[:file].blank?)
    end if params[:files]

  end

end
