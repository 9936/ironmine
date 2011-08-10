class Skm::ColumnsController < ApplicationController
  def index

  end

  def new
    @column = Skm::Column.new
    if params[:parent_column_id].present?
      @column.parent_column_id=params[:parent_column_id]
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @column }
    end
  end

  def create
    @column = Skm::Column.new(params[:skm_column])
    @column.parent_column_id=params[:skm_columns]
    respond_to do |format|
      if @column.save
        format.html { redirect_to({:action=>"index"}, :notice =>t(:successfully_created)) }
        format.xml  { render :xml => @column, :status => :created, :location => @column }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @column.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @column = Skm::Column.multilingual.find(params[:id])
  end

  def update
    @column = Skm::Column.find(params[:id])
    @column.parent_column_id=params[:skm_columns] if params[:skm_columns].present?
    respond_to do |format|
      if @column.update_attributes(params[:skm_column])
        format.html {
          if params[:return_url].blank?
            redirect_to({:action=>"index"},:notice => (t :successfully_created))
          else
            redirect_to(params[:return_url],:notice => (t :successfully_created))
          end }
        format.xml  { head :ok }
      else
        @error = @column
        format.html { render "edit" }
        format.xml  { render :xml => @column.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_columns_data
    tree_nodes = []
    @skm_columns = Skm::Column.multilingual.where("LENGTH(parent_column_id) = 0")
    @skm_columns.each do |sc|
      is_leaf = sc.is_leaf?
      sc_node = {:id => sc.id, :text => sc[:name], :column_name => sc[:name],
                 :column_description => sc[:description], :sc_id => sc.id,
                 :sc_code => sc.column_code, :leaf => is_leaf, :children=>[], :checked => false}
      sc_node[:children] = sc.get_child_nodes(params[:with_check])
      sc_node.delete(:children) if sc_node[:children].size == 0
      sc_node.delete(:checked) unless params[:with_check]
      sc_node[:checked] = true if params[:with_check].present? && params[:with_check].split(",").include?(sc.id.to_s)
      tree_nodes << sc_node
    end

    respond_to do |format|
      format.json {render :json=>tree_nodes.to_json}
    end
  end
end