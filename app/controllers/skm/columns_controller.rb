class Skm::ColumnsController < ApplicationController
  def index

  end

  def new
    @column = Skm::Column.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @column }
    end
  end

  def create
    @column = Skm::Column.new(params[:skm_column])
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

  end

  def update

  end

  def get_columns_data
    tree_nodes = []

    @skm_columns = Skm::Column.multilingual.where("LENGTH(parent_column_id) = 0")

    @skm_columns.each do |sc|
      is_leaf = sc.is_leaf?
      sc_node = {:id => sc.id, :text => sc[:name], :sc_id => sc.id, :sc_code => sc.column_code, :leaf => is_leaf, :children=>[]}
      sc_node[:children] = sc.get_child_nodes
      sc_node.delete(:children) if sc_node[:children].size == 0

      tree_nodes << sc_node
    end

    respond_to do |format|
      format.json {render :json=>tree_nodes.to_json}
    end
  end
end