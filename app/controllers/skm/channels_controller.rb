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
    channels,count = paginate(channel_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(channels.to_grid_json(['0',:channel_code, :name,:description,:status_meaning, :status_code], count)) }
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
    channel_scope = Irm::Group.find(params[:group_id]).channels.multilingual.status_meaning
    channels,count = paginate(channel_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(channels.to_grid_json(['0',:channel_code, :name,:description,:status_meaning, :status_code], count)) }
    end
  end

  def get_ava_channels
    channel_scope = Skm::Channel.multilingual.without_group(params[:group_id]).status_meaning
    channels,count = paginate(channel_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(channels.to_grid_json(['0',:channel_code, :name,:description,:status_meaning, :status_code], count)) }
    end
  end
end