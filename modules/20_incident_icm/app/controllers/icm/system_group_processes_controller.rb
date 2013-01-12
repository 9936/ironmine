class Icm::SystemGroupProcessesController < ApplicationController
  # GET /system_support_group_filters
  # GET /system_support_group_filters.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @system_support_group_filters }
    end
  end

  # GET /system_support_group_filters/1
  # GET /system_support_group_filters/1.xml
  def show
    @system_support_group_filter = Icm::SystemGroupProcess.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @system_support_group_filter }
    end
  end

  # GET /system_support_group_filters/new
  # GET /system_support_group_filters/new.xml
  def new
    @system_group_process = Icm::SystemGroupProcess.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @system_group_process }
    end
  end

  # GET /system_support_group_filters/1/edit
  def edit
    @system_group_process = Icm::SystemGroupProcess.find(params[:id])
  end

  # POST /system_support_group_filters
  # POST /system_support_group_filters.xml
  def create
    @system_group_process = Icm::SystemGroupProcess.new(params[:icm_system_group_process])
    @system_group_process.external_system_id = Irm::ExternalSystem.current_system.id

    respond_to do |format|
      if @system_group_process.save
        #保存支持组流向关系
        if params[:support_group_to_ids]
          params[:support_group_to_ids].each do |from_id, to_ids|
            if from_id and from_id.present? and to_ids and to_ids.any?
              to_ids.each do |to_id|
                Icm::GroupProcessRelation.create(:group_process_id => @system_group_process.id,
                                                 :support_group_from => from_id,
                                                 :support_group_to => to_id ) if to_id.present?
              end
            end
          end
        end

        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @system_group_process, :status => :created, :location => @system_group_process }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @system_group_process.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /system_support_group_filters/1
  # PUT /system_support_group_filters/1.xml
  def update
    @system_group_process = Icm::SystemGroupProcess.find(params[:id])

    respond_to do |format|
      if @system_support_group_filter.update_attributes(params[:system_support_group_filter])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @system_support_group_filter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /system_support_group_filters/1
  # DELETE /system_support_group_filters/1.xml
  def destroy
    @system_group_process = Icm::SystemGroupProcess.find(params[:id])
    @system_group_process.destroy

    respond_to do |format|
      format.html { redirect_to(system_group_process_url) }
      format.xml  { head :ok }
    end
  end


  def get_data
    system_group_processes_scope = Icm::SystemGroupProcess.list_all
    system_group_processes,count = paginate(system_group_processes_scope)
    group_process_ids = system_group_processes.map(&:id)
    group_processes = Icm::GroupProcessRelation.list_all.where(:group_process_id => group_process_ids)
    @processes_hash = {}
    group_processes.each do |gp|
      @processes_hash[gp.group_process_id] ||= []
      @processes_hash[gp.group_process_id] << gp
    end

    respond_to do |format|
      format.html  {
        @datas = system_group_processes
        @count = count
      }
    end
  end

  def switch_sequence

  end

  def get_groups_processes
    @group_processes = Icm::GroupProcessRelation.list_all.with_process(params[:id])
  end

end
