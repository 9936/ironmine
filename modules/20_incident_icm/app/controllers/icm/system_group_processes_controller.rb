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
    #查找出对应关系
    relations = Icm::GroupProcessRelation.where("group_process_id=?", @system_group_process.id)
    @relations_hash = {}
    relations.each do |relation|
      @relations_hash[relation.support_group_from.to_sym] ||= []
      @relations_hash[relation.support_group_from.to_sym] << relation.support_group_to
    end
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
      if @system_group_process.update_attributes(params[:icm_system_group_process])
        #删除已有流程关系
        process_relations = Icm::GroupProcessRelation.where("group_process_id=?", @system_group_process.id)
        process_relations.each do |pr|
          pr.destroy
        end
        #创建新的流程关系
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


        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @system_group_process.errors, :status => :unprocessable_entity }
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
    system_group_processes_scope = Icm::SystemGroupProcess.list_all(Irm::ExternalSystem.current_system.id)
    system_group_processes = system_group_processes_scope
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
        @count = system_group_processes.count
      }
    end
  end

  def switch_sequence
    sequence_str = params[:ordered_ids]
    if sequence_str.present?
      sequence = 1
      process_ids = sequence_str.split(",")
      group_processes = Icm::SystemGroupProcess.where(:id => process_ids).index_by(&:id)
      process_ids.each do |id|
        group_process = group_processes[id]
        group_process.display_sequence = sequence
        group_process.save
        sequence += 1
      end
    end
    respond_to do |format|
      format.json  {render :json => {:success => true}}
    end
  end

  #def get_groups_processes
  #  @group_processes = Icm::GroupProcessRelation.list_all.with_process(params[:id])
  #end

end
