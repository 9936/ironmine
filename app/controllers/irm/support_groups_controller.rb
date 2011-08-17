class Irm::SupportGroupsController < ApplicationController
  # GET /support_groups
  # GET /support_groups.xml
  def index
    all_groups = Irm::SupportGroup.list_all

    grouped_groups = all_groups.collect{|i| [i.id,i.parent_group_id]}.group_by{|i|i[1].present? ? i[1] : "blank"}

    groups = {}
    all_groups.each do |ar|
      groups.merge!({ar.id=>ar})
    end
    @level_groups = []

    proc = Proc.new{|parent_group_id,level|
      if(grouped_groups[parent_group_id.to_s]&&grouped_groups[parent_group_id.to_s].any?)

        grouped_groups[parent_group_id.to_s].each do |r|
          groups[r[0]].level = level
          @level_groups << groups[r[0]]

          proc.call(groups[r[0]].id,level+1)
        end
      end
    }

    grouped_groups["blank"].each do |gr|
      groups[gr[0]].level = 1
      @level_groups << groups[gr[0]]
      proc.call(groups[gr[0]].id,2)
    end
  end

  # GET /support_groups/1
  # GET /support_groups/1.xml
  def show
    @support_group = Irm::SupportGroup.multilingual.query_wrap_info(I18n.locale).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @support_group }
    end
  end

  # GET /support_groups/new
  # GET /support_groups/new.xml
  def new
    @support_group = Irm::SupportGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @support_group }
    end
  end

  # GET /support_groups/1/edit
  def edit
    @support_group = Irm::SupportGroup.multilingual.find(params[:id])
  end

  # POST /support_groups
  # POST /support_groups.xml
  def create
    @support_group = Irm::SupportGroup.new(params[:irm_support_group])

    respond_to do |format|
      if @support_group.save
        format.html { redirect_to({:action=>"index"},:notice => (t :successfully_created))}
        format.xml  { render :xml => @support_group, :status => :created, :location => @support_group }
      else
        @error = @support_group
        format.html { render "new" }
        format.xml  { render :xml => @support_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /support_groups/1
  # PUT /support_groups/1.xml
  def update
    @support_group = Irm::SupportGroup.find(params[:id])

    respond_to do |format|
      if @support_group.update_attributes(params[:irm_support_group])
        format.html { redirect_to({:action=>"index"},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
      else
        @error = @support_group
        format.html { render "edit" }
        format.xml  { render :xml => @support_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  def multilingual_edit
    @support_group = Irm::SupportGroup.find(params[:id])
  end

  def multilingual_update
    @support_group = Irm::SupportGroup.find(params[:id])
    @support_group.not_auto_mult=true
    respond_to do |format|
      if @support_group.update_attributes(params[:irm_support_group])
        format.html { redirect_to({:action=>"show"}) }
      else
        format.html { render({:action=>"multilingual_edit"}) }
      end
    end
  end

  def get_data
    @support_groups= Irm::SupportGroup.multilingual.query_wrap_info(I18n::locale)
    @support_groups = @support_groups.match_value("#{Irm::SupportGroup.table_name}.group_code",params[:group_code])
    @support_groups = @support_groups.match_value("#{Irm::SupportGroupsTl.table_name}.name",params[:name])
    @support_groups = @support_groups.match_value("v2.company_name",params[:company_name])
    @support_groups = @support_groups.match_value("v3.organization_name",params[:organization_name])
    @support_groups,count = paginate(@support_groups)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@support_groups.to_grid_json(['R',:company_name,:organization_name,:group_code,:name,
                                                                  :support_role_name,:vendor_group_flag,
                                                                  :oncall_group_flag,:status_meaning, :assignment_process],
                                                                 count))}
    end
  end

  def add_persons
    @support_group_code = params[:support_group_code]
  end

  def get_support_group_member
    @support_group_code = params[:support_group_code]
    @support_group_member= Irm::SupportGroupMember.query_wrap_info(I18n::locale,@support_group_code)
    respond_to do |format|
      format.json {render :json=>@support_group_member.to_dhtmlxgrid_json(['R',:person_name,:company_name,
                                                                           :email_address,:mobile_phone,:status_meaning],
                                                                          @support_group_member.size)}
    end
  end

  def choose_person
     @support_group_code = params[:support_group_code]
     @support_group = Irm::SupportGroup.query_by_support_group_code(@support_group_code)
  end

  def create_member
    person_list = params[:person_choose_list].split(',')
    support_group_code = params[:support_group_code]
    flag = true
    if ((!person_list.blank?) && !(support_group_code.blank?))
      person_list.each do |person_id|
        if Irm::SupportGroupMember.check_person_exists?(support_group_code,person_id)
            @support_group_member = Irm::SupportGroupMember.new(:person_id => person_id,
                                           :support_group_code =>support_group_code )
            if !@support_group_member.save
              flag=false
            end
        end
      end
    end
    if flag
      respond_to do |format|
         flash[:successful_message] = (t :successfully_created)
         format.html { render "irm/common/_successful_message" }
      end
    else
      respond_to do |format|
         format.html { render "irm/common/_successful_message" }
      end
    end
  end

  def delete_member
    id_delete_list = params[:id_delete_list].split(',')
    support_group_code = params[:support_group_code]
    if ((!id_delete_list.blank?) || !(support_group_code.blank?))
      Irm::SupportGroupMember.delete_by_id(id_delete_list)    
      respond_to do |format|
        flash[:successful_message] = (t :successfully_deleted)
        format.html { render "irm/common/_successful_message" }
        format.xml  { head :ok }
      end
    end
  end
end
