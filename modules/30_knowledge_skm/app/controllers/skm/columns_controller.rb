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
    @column.parent_column_id=params[:skm_columns] if params[:skm_columns].present?
    respond_to do |format|
      if @column.save
#         @column.create_access_from_str
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

  def show
    @column = Skm::Column.multilingual.find(params[:id])
  end

  def multilingual_edit
    @column = Skm::Column.find(params[:id])
  end

  def multilingual_update
    @column = Skm::Column.find(params[:id])
    @column.not_auto_mult = true
    respond_to do |format|
      if @column.update_attributes(params[:skm_column])
        format.html { redirect_to({:action=>"show"}, :notice => 'Column was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "multilingual_edit" }
        format.xml  { render :xml => @column.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @column = Skm::Column.find(params[:id])
    @column.parent_column_id=params[:skm_columns] if params[:skm_columns].present?
    respond_to do |format|
      if @column.update_attributes(params[:skm_column])
#         @column.create_access_from_str
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
    column_ids = Skm::Column.current_person_accessible_columns if params[:access]
    @skm_columns = Skm::Column.multilingual.where("parent_column_id IS NULL OR LENGTH(parent_column_id) = 0")
    @skm_columns.each do |sc|
      is_leaf = sc.is_leaf?
      display = params[:access] ? column_ids.include?(sc.id) : true
      column_accesses = ""
      ca_recs = sc.column_accesses.uniq
      ca_recs.each do |ca|
        begin
          column_accesses << t("label_" + ca.source_type.underscore.gsub("\/","_")) + ":" + ca.source.to_s
        rescue
          column_accesses << ca.source_type + "-" + ca.source_id
        end
        (column_accesses << ", " )if ca != ca_recs.last
      end

      sc_node = {:id => sc.id, :text => sc[:name], :column_name => sc[:name],
                 :column_description => sc[:description], :sc_id => sc.id,
                 :column_accesses => column_accesses,
                 :sc_code => sc.column_code, :leaf => is_leaf, :children=>[], :checked => false, :expanded => true,:iconCls=>"x-tree-icon-parent"}
      sc_node[:children] = sc.get_child_nodes(params[:access], params[:with_check], column_ids)
      sc_node.delete(:children) if sc_node[:children].size == 0
      sc_node.delete(:checked) unless params[:with_check]
      sc_node[:checked] = true if params[:with_check].present? && params[:with_check].split(",").include?(sc.id.to_s)
      sc_node[:leaf] = sc_node[:children].nil?

      next unless display || !sc_node[:children].nil?
      tree_nodes << sc_node
    end
    tree_nodes << {:id => "", :text => I18n.t(:uncategory), :column_name => I18n.t(:uncategory),
                 :column_description => I18n.t(:uncategory), :sc_id => "",
                 :column_accesses => "",
                 :sc_code => "", :leaf => true, :children=>[]} if params[:show_uncolumn]
    respond_to do |format|
      format.json {render :json=>tree_nodes.to_json}
    end
  end
end