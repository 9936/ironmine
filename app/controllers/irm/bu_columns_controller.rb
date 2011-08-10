class Irm::BuColumnsController < ApplicationController
  def index

  end

  def new
    @bu_column = Irm::BuColumn.new
    if params[:parent_column_id].present?
      @bu_column.parent_column_id=params[:parent_column_id]
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bu_column }
    end
  end

  def create
    @bu_column = Irm::BuColumn.new(params[:irm_bu_column])
    @bu_column.parent_column_id=params[:irm_bu_columns]
    respond_to do |format|
      if @bu_column.save
        format.html { redirect_to({:action=>"index"}, :notice =>t(:successfully_created)) }
        format.xml  { render :xml => @bu_column, :status => :created, :location => @bu_column }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bu_column.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @bu_column = Irm::BuColumn.multilingual.find(params[:id])
  end

  def update
    @bu_column = Irm::BuColumn.find(params[:id])
    @bu_column.parent_column_id=params[:irm_bu_columns] if params[:irm_bu_columns].present?
    respond_to do |format|
      if @bu_column.update_attributes(params[:irm_bu_column])
        format.html {
          if params[:return_url].blank?
            redirect_to({:action=>"index"},:notice => (t :successfully_created))
          else
            redirect_to(params[:return_url],:notice => (t :successfully_created))
          end }
        format.xml  { head :ok }
      else
        @error = @bu_column
        format.html { render "edit" }
        format.xml  { render :xml => @bu_column.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_columns_data
    tree_nodes = []
    @bu_columns = Irm::BuColumn.multilingual.where("LENGTH(parent_column_id) = 0")
    @bu_columns.each do |sc|
      is_leaf = sc.is_leaf?
      sc_node = {:id => sc.id, :text => sc[:name], :column_name => sc[:name],
                 :column_description => sc[:description], :sc_id => sc.id,
                 :sc_code => sc.bu_column_code, :leaf => is_leaf, :children=>[], :checked => false}
      puts("+++++++++++++++++++++++" + params.to_json)
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