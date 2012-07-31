class Irm::OrgDataAccessesController < ApplicationController
  def index

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => nil }
    end
  end

  def show
    Irm::DataAccess.prepare_for_opu
    @data_accesses = Irm::DataAccess.opu_data_access.list_all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @data_accesses }
    end
  end

  def edit

  end

  def update
    access_levels = params[:access_levels]
    all_data_accesses =    {}
    Irm::DataAccess.org_data_access(params[:id]).each do |data_access|
      all_data_accesses[data_access.business_object_id] =  data_access
    end
    access_levels.each do |business_object_id,access_level|
      next unless access_level.present?
      if all_data_accesses[business_object_id]
        all_data_accesses[business_object_id].update_attribute(:access_level,access_level)
      else
        Irm::DataAccess.create(:business_object_id=>business_object_id,:organization_id=>params[:id],:access_level=>access_level)
      end
    end
  end
end
