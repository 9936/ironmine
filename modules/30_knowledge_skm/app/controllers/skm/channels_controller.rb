class Skm::ChannelsController < ApplicationController
  def index

  end

  def create
    @channel = Skm::Channel.new(params[:skm_channel])
    column_ids = params[:skm_channel][:column_ids].split(",")
    respond_to do |format|
      if @channel.save
        column_ids.each do |c|
          Skm::ChannelColumn.create(:channel_id => @channel.id, :column_id => c)
        end
        format.html { redirect_to({:action=>"index"}, :notice =>t(:successfully_created)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def new
    @channel = Skm::Channel.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @channel = Skm::Channel.multilingual.find(params[:id])
    @channel.column_ids = @channel.get_column_ids
  end

  def update
    @channel = Skm::Channel.find(params[:id])
    column_ids = params[:skm_channel][:column_ids].split(",")
    owned_column_ids = @channel.get_column_ids.split(",")
    respond_to do |format|
      if @channel.update_attributes(params[:skm_channel])
        (owned_column_ids - column_ids).each do |c|
          Skm::ChannelColumn.where(:channel_id => @channel.id, :column_id => c).each do |t|
            t.destroy
          end
        end
        (column_ids - owned_column_ids).each do |c|
          Skm::ChannelColumn.create(:channel_id => @channel.id, :column_id => c)
        end
        format.html { redirect_to({:action=>"index"}, :notice => t(:successfully_updated)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def show
    @channel = Skm::Channel.multilingual.find(params[:id])
    @channel.column_ids = @channel.get_column_ids
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def get_data
    channel_scope = Skm::Channel.multilingual.status_meaning
    channel_scope = channel_scope.match_value("#{Skm::Channel.table_name}.channel_code",params[:channel_code])
    channel_scope = channel_scope.match_value("#{Skm::ChannelsTl.table_name}.name",params[:name])
    channels,count = paginate(channel_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(channels.to_grid_json([:channel_code, :name,:description,:status_meaning, :status_code], count)) }
      format.html  {
        @datas = channels
        @count = count
      }
    end
  end

  def multilingual_edit
    @channel = Skm::Channel.find(params[:id])
  end

  def multilingual_update
    @channel = Skm::Channel.find(params[:id])
    @channel.not_auto_mult=true
    respond_to do |format|
      if @channel.update_attributes(params[:skm_channel])
        format.html { redirect_to({:action=>"show"}) }
      else
        format.html { render({:action=>"multilingual_edit"}) }
      end
    end
  end

  def get_all_columns_data

  end

  def get_owned_channels
    channel_scope = Irm::Group.find(params[:group_id]).channels.multilingual.enabled.status_meaning
    channels,count = paginate(channel_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(channels.to_grid_json(['0',:channel_code, :name,:description,:status_meaning, :status_code], count)) }
    end
  end

  def get_ava_channels
    channel_scope = Skm::Channel.multilingual.without_group(params[:group_id]).enabled.status_meaning
    channels,count = paginate(channel_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(channels.to_grid_json(['0',:channel_code, :name,:description,:status_meaning, :status_code], count)) }
    end
  end

  def get_owned_groups_data
    group_scope = Skm::Channel.find(params[:id]).groups.multilingual.enabled
    group_scope = group_scope.match_value("#{Irm::Group.table_name}.code",params[:code])
    group_scope = group_scope.match_value("#{Irm::GroupsTl.table_name}.name",params[:name])
    groups, count = paginate(group_scope)
    respond_to do |format|
      format.html {
        @channel_id=params[:id]
        @datas=groups
        @count=count
      }
      format.json  {render :json => to_jsonp(groups.to_grid_json(['0',:code, :name, :description, :status_code], count)) }
    end
  end

  def get_ava_groups_data
    group_scope = Irm::Group.multilingual.where("#{Irm::Group.table_name}.id NOT IN (?)", Skm::Channel.find(params[:id]).groups.collect(&:id) + ['']).enabled
    group_scope = group_scope.match_value("#{Irm::Group.table_name}.code",params[:code])
    group_scope = group_scope.match_value("#{Irm::GroupsTl.table_name}.name",params[:name])
    groups, count = paginate(group_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(groups.to_grid_json(['0',:code, :name, :description, :status_code], count)) }
      format.html {
        @datas = groups
        @count = count
      }
    end
  end

  #添加审核人员相关的actions
  def get_approvals_data
    people_scope =  Irm::Person.with_organization(I18n.locale).with_channel_groups(params[:id]).without_approvals(params[:id])

    #确保查询的人具有审核知识的权限
    people_scope = people_scope.with_profiles_by_function_code('APPROVE_SKM_ENTRIES')
    people_scope = people_scope.match_value("#{Irm::Person.table_name}.full_name",params[:full_name])
    people_scope = people_scope.match_value("#{Irm::Person.table_name}.email_address",params[:email_address])
    people_scope = people_scope.match_value("#{Irm::Organization.view_name}.name",params[:organization_name])
    people, count = paginate(people_scope)
    respond_to do |format|
      format.html {
        @datas = people
        @count = count
      }
      format.json {render :json => people }
    end
  end

  def get_owned_approvals_data
    approval_scope = Irm::Person.with_organization(I18n.locale).with_approvals(params[:id])
    approval_scope = approval_scope.match_value("#{Irm::Person.table_name}.full_name",params[:full_name])
    approval_scope = approval_scope.match_value("#{Irm::Person.table_name}.email_address",params[:email_address])
    approval_scope = approval_scope.match_value("#{Irm::Organization.view_name}.name",params[:organization_name])
    approvals, count = paginate(approval_scope)
    respond_to do |format|
      format.html {
        @channel_id=params[:id]
        @datas = approvals
        @count = count
      }
      format.json  {render :json => approvals }
    end
  end

  def new_approvals
    @channel = Skm::Channel.multilingual.find(params[:id])
    @channel_approval = Skm::ChannelApprovalPerson.new
    @channel_approval.status_code = ""
  end

  def create_approvals
    @channel = Skm::Channel.find(params[:id])
    person_ids = params[:skm_channel_approval_person][:status_code]
    respond_to do |format|
      if person_ids.present?
        person_ids.split(",").delete_if{|i| i.blank?}.each do |id|
          approval_person = Skm::ChannelApprovalPerson.where("person_id =? AND channel_id = ?",id, @channel.id).first
          unless approval_person.present?
            Skm::ChannelApprovalPerson.create(:person_id=>id,:channel_id=>@channel.id)
          end
        end
        format.html { redirect_to({:controller => "skm/channels",:action=>"show",:id=>@channel.id}, :notice => t(:successfully_created)) }
      else
        format.html { render :action => "new_approvals" }
      end
    end
  end

  def remove_approval
    approval_person = Skm::ChannelApprovalPerson.where("person_id =? AND channel_id = ? AND opu_id = ?",params[:person_id], params[:channel_id], Irm::OperationUnit.current.id).first
    unless approval_person.nil?
     if approval_person.destroy
       #删除该用户下所有未审核的知识库标记记录
       entry_approvals = Skm::EntryApprovalPerson.where("person_id=? AND opu_id = ?", params[:person_id], Irm::OperationUnit.current.id)
       if entry_approvals.any?
          entry_approvals.each do |entry_approval|
            #如果知识库仅为当前用户审核则将知识库自动发布
            unless Skm::EntryApprovalPerson.has_other_approval_people?(entry_approval[:entry_header_id], entry_approval[:person_id])
              Skm::EntryHeader.where("id=?", entry_approval[:entry_header_id]).update_all(:entry_status_code=>"PUBLISHED") #更新为发布状态
            end
            entry_approval.destroy
          end
       end
     end
    end
    respond_to do |format|
      format.html { redirect_to({:controller=>"skm/channels",:action=>"show",:id=>params[:channel_id]}) }
      format.xml  { head :ok }
    end
  end

  def remove_group
    @group_member = Skm::ChannelGroup.where("group_id =? AND channel_id = ? AND opu_id = ?",
                                            params[:group_id], params[:channel_id], Irm::OperationUnit.current.id).first
    @group_member.destroy

    respond_to do |format|
      format.html { redirect_to({:controller=>"skm/channels",:action=>"show",:id=>params[:channel_id]}) }
      format.xml  { head :ok }
    end
  end

  def new_groups
    @channel = Skm::Channel.multilingual.find(params[:id])
    @channel_group = Skm::ChannelGroup.new
    @channel_group.status_code = ""
  end

  def create_groups
    @channel = Skm::Channel.find(params[:id])
    @channel_group = Skm::ChannelGroup.new(params[:skm_channel_group])
    respond_to do |format|
      if(!@channel_group.status_code.blank?)
        @channel_group.status_code.split(",").delete_if{|i| i.blank?}.each do |id|
          Skm::ChannelGroup.create(:group_id=>id,:channel_id=>@channel.id)
        end
        format.html { redirect_to({:controller => "skm/channels",:action=>"show",:id=>@channel.id}, :notice => t(:successfully_created)) }
      else
        @channel_group.errors.add(:status_code,"")
        format.html { render :action => "new_groups" }
      end
    end
  end
end