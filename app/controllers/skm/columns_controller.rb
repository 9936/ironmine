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
    access_types = [[Irm::Company,"C"],[Irm::Organization,"O"],[Irm::Department,"D"],[Irm::Profile,"R"]]
    @column.parent_column_id=params[:skm_columns]
    respond_to do |format|
      if @column.save

        if params[:selected_actions] && params[:selected_actions].present?
          selected_accesses = params[:selected_actions].split(",")
          selected_accesses.each do |access_str|
            next unless access_str.strip.present?
            access = access_str.split("#")
            access_type = access_types.detect{|i| i[1].eql?(access[0])}
            Skm::ColumnAccess.create({:column_id => @column.id,
                                        :source_type => access_type[0].name,
                                        :source_id => access[1]})
          end if selected_accesses.any?
        end

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
    access_types = [[Irm::Company,"C"],[Irm::Organization,"O"],[Irm::Department,"D"],[Irm::Profile,"R"]]
    @column.parent_column_id=params[:skm_columns] if params[:skm_columns].present?
    respond_to do |format|
      if @column.update_attributes(params[:skm_column])

        selected_accesses = params[:selected_actions].split(",")

        column_access_records = @column.column_accesses
        column_access_records.each do |t|
          type_short = access_types.detect{|i| i[0].name.eql?(t.source_type)}
          t.destroy unless selected_accesses.include?(type_short[1]+"#"+t.source_id.to_s)
        end
        column_accesses_array = @column.column_accesses.collect{|p| [p.source_type, p.source_id]}

        selected_accesses.each do |access_str|
          next unless access_str.strip.present?
          access = access_str.split("#")
          access_type = access_types.detect{|i| i[1].eql?(access[0])}
          next if column_accesses_array.include?([access_type[0].name, access[1]])

          Skm::ColumnAccess.create({:column_id => @column.id,
                                      :source_type => access_type[0].name,
                                      :source_id => access[1]})
        end

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