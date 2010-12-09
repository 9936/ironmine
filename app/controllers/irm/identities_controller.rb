class Irm::IdentitiesController < ApplicationController
  def index
    @identity = Irm::Identity.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @identity }
    end
  end

  def show
    @identity = Irm::Identity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @identity }
    end
  end

  def new
    @identity = Irm::Identity.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @identity }
    end
  end

  def edit
    @identity = Irm::Identity.find(params[:id])
  end

  def create
    @identity = Irm::Identity.new(params[:irm_identity])

    respond_to do |format|
      if @identity.save
        flash[:successful_message] = (t :successfully_created)
        format.html { render "successful_info" }
      else
         @error = @identity
         format.html { render "error_message" }
      end
    end
  end

  def update
    @identity = Irm::Identity.find(params[:id])

    respond_to do |format|
      if @identity.update_attributes(params[:irm_identity])
        flash[:successful_message] = (t :successfully_updated)
        format.html { render "successful_info" }
      else
        @error = @identity
        format.html { render "error_message" }
      end
    end
  end

  def destroy
    @identity = Irm::Identity.find(params[:id])
    @identity.destroy

    respond_to do |format|
      format.html { redirect_to(permissions_url) }
      format.xml  { head :ok }
    end
  end

  def get_data
    @identitys = Irm::Identity.query_all.with_language
    respond_to do |format|
      format.json  {render :json => @identitys.to_dhtmlxgrid_json(['0',:login_name,:full_name,
                                                                     :email,:language_description,:status_code,
                                                                    {:value => 'M', :controller => 'irm/permissions',:action =>  'multilingual_edit', :id => 'id', :action_type => 'multilingual',:view_port=>'data_area', :script => ''}
                                                                    ], @identitys.size) }
    end
  end
end
