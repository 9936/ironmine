class Mam::MastersController < ApplicationController
  layout 'application'

  def index
    session[:_view_filter_id] = params[:filter_id] if params[:filter_id]
    respond_to do |format|
      format.html { render :layout => "application_full" } # new.html.erb
    end
  end

  def show
    @master = Mam::Master.
        with_support_group.
        with_supporter.
        with_submitted_by.
        with_master_status.
        with_category.
        with_system.
        select_all.
        find(params[:id])
    @show_form = true
    @master_replies = @master.master_replies.select_all.with_reply_br.with_reply_person.order("#{Mam::MasterReply.table_name}.created_at ASC")
    @master_reply = Mam::MasterReply.new()
    respond_to do |format|
      format.html{ render :layout=>"application_full"}# show.html.erb
      format.xml { render :xml => @master }
    end
  end

  def new

  end

  def new_item
    @master = Mam::Master.new()
    @master_item = Mam::MasterItem.new()
    @temp_master_id = Fwk::IdGenerator.instance.generate(Mam::Master.table_name)
    @return_url=request.env['HTTP_REFERER']
    respond_to do |format|
      format.html { render :layout => "application_full" } # new.html.erb
    end
  end

  def edit_item
    @master = Mam::Master.select_all.with_submitted_by.find(params[:id])
    @master_item = Mam::MasterItem.new()
    @temp_master_id = Fwk::IdGenerator.instance.generate(Mam::Master.table_name)
    @return_url=request.env['HTTP_REFERER']
    respond_to do |format|
      format.html { render :layout => "application_full" } # new.html.erb
    end
  end

  def update_item
    @master = Mam::Master.find(params[:id])

    respond_to do |format|
      Mam::MasterItem.where("master_id = ?", params[:temp_master_id]).each do |t|
        t.update_attribute(:master_id, @master.id)
      end
      format.html { redirect_to({:action=>"show", :id => @master.id}, :notice =>t(:successfully_created)) }
      format.xml  { render :xml => @master, :status => :created, :location => @master }
    end
  end

  def create_item
    @master = Mam::Master.new(params[:mam_master])
    @master.master_type="Item"
    @master.submitted_by=Irm::Person.current.id
    @master.master_number = Irm::Sequence.nextval("MAM::MasterNumber")
    @master.master_status = "MAM_NEW"
    @master.support_group_id = "000Q00091nxNqRI7bBNZXU"
    @master.save
    Mam::MasterStatus.create({:master_number => @master.master_number,
                              :master_type => @master.master_type,
                              :category => @master.category,
                              :system_id => @master.system_id,
                              :submitted_by => @master.submitted_by,
                              :master_status => @master.master_status,
                              :support_group_id =>@master.support_group_id,
                              :support_person_id => @master.support_person_id,
                              :remark => @master.remark,
                              :contact=> @master.contact,
                              :contact_number=> @master.contact_number,
                              :urs_user_name=> @master.urs_user_name,
                              :urs_start_date=> @master.urs_start_date,
                              :urs_end_date=> @master.urs_end_date,
                              :urs_person=> @master.urs_person,
                              :urs_description=> @master.urs_description,
                              :urs_status=> @master.urs_status,
                              :urs_email=> @master.urs_email,
                              :status_code=> @master.status_code})
    
    respond_to do |format|
      if @master.save
        Mam::MasterItem.where("master_id = ?", params[:temp_master_id]).each do |t|
          t.update_attribute(:master_id, @master.id)
        end
        format.html { redirect_to({:action=>"show", :id => @master.id}, :notice =>t(:successfully_created)) }
        format.xml  { render :xml => @master, :status => :created, :location => @master }
      else
        @master_item = Mam::MasterItem.new()
        @temp_master_id = params[:temp_master_id]
        format.html { render :action => "new_item",:layout => "application_full" }
        format.xml  { render :xml => @master.errors, :status => :unprocessable_entity }
      end
    end
  end

  def new_scs
    @master = Mam::Master.new()
    respond_to do |format|
      format.html { render :layout => "application_full" } # new.html.erb
    end
  end

  def create_scs
    @master = Mam::Master.new(params[:mam_master])
    @master.master_type="Supplier&Customer"
    @master.submitted_by=Irm::Person.current.id
    @master.master_number = Irm::Sequence.nextval("MAM::MasterNumber")
    @master.master_status = "MAM_NEW"
    @master.support_group_id = "000Q00091nxNqRI7bBNZXU"
    @master.master_scs.build(params[:master_sc])
    @master.save
    Mam::MasterStatus.create({:master_number => @master.master_number,
                              :master_type => @master.master_type,
                              :category => @master.category,
                              :system_id => @master.system_id,
                              :submitted_by => @master.submitted_by,
                              :master_status => @master.master_status,
                              :support_group_id =>@master.support_group_id,
                              :support_person_id => @master.support_person_id,
                              :remark => @master.remark,
                              :contact=> @master.contact,
                              :contact_number=> @master.contact_number,
                              :urs_user_name=> @master.urs_user_name,
                              :urs_start_date=> @master.urs_start_date,
                              :urs_end_date=> @master.urs_end_date,
                              :urs_person=> @master.urs_person,
                              :urs_description=> @master.urs_description,
                              :urs_status=> @master.urs_status,
                              :urs_email=> @master.urs_email,
                              :status_code=> @master.status_code})
    respond_to do |format|
      if @master.save
        format.html { redirect_to({:action=>"show", :id => @master.id}, :notice =>t(:successfully_created)) }
        format.xml  { render :xml => @master, :status => :created, :location => @master }
      else
        format.html { render :action => "new_scs",:layout => "application_full" }
        format.xml  { render :xml => @master.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit_scs
    @master = Mam::Master.find(params[:id])
    @return_url=request.env['HTTP_REFERER']
    respond_to do |format|
      format.html { render :layout => "application_full" } # new.html.erb
    end
  end

  def update_scs
    @master = Mam::Master.find(params[:id])
    @master_sc = @master.master_scs.first
    @master.update_attributes(params[:mam_master])
    @master_sc.update_attributes(params[:master_sc])

    respond_to do |format|
        format.html { redirect_to({:action=>"show", :id => @master.id}, :notice =>t(:successfully_created)) }
    end
  end

  def new_urs
    @master = Mam::Master.new()
    @master_ur = Mam::MasterUr.new()
    @temp_master_id = Fwk::IdGenerator.instance.generate(Mam::Master.table_name)
    @return_url=request.env['HTTP_REFERER']
    respond_to do |format|
      format.html { render :layout => "application_full" } # new.html.erb
    end
  end

  def edit_urs
    @master = Mam::Master.select_all.with_submitted_by.find(params[:id])
    @master_ur = Mam::MasterUr.new()
    @temp_master_id = Fwk::IdGenerator.instance.generate(Mam::Master.table_name)
    @return_url=request.env['HTTP_REFERER']
    respond_to do |format|
      format.html { render :layout => "application_full" } # new.html.erb
    end
  end

  def update_urs
    @master = Mam::Master.find(params[:id])
    @master.update_attributes(params[:mam_master])
    respond_to do |format|
      Mam::MasterUr.where("master_id = ?", params[:temp_master_id]).each do |t|
        t.update_attribute(:master_id, @master.id)
      end
      format.html { redirect_to({:action=>"show", :id => @master.id}, :notice =>t(:successfully_created)) }
      format.xml  { render :xml => @master, :status => :created, :location => @master }
    end
  end

  def create_urs
    @master = Mam::Master.new(params[:mam_master])
    #build master
    @master.master_type="User&Responsibility"
    @master.submitted_by=Irm::Person.current.id
    @master.master_number = Irm::Sequence.nextval("MAM::MasterNumber")
    @master.master_status = "MAM_NEW"
    @master.support_group_id = "000Q00091nxNqRI7bBNZXU"
    @master.save
    Mam::MasterStatus.create({:master_number => @master.master_number,
                              :master_type => @master.master_type,
                              :category => @master.category,
                              :system_id => @master.system_id,
                              :submitted_by => @master.submitted_by,
                              :master_status => @master.master_status,
                              :support_group_id =>@master.support_group_id,
                              :support_person_id => @master.support_person_id,
                              :remark => @master.remark,
                              :contact=> @master.contact,
                              :contact_number=> @master.contact_number,
                              :urs_user_name=> @master.urs_user_name,
                              :urs_start_date=> @master.urs_start_date,
                              :urs_end_date=> @master.urs_end_date,
                              :urs_person=> @master.urs_person,
                              :urs_description=> @master.urs_description,
                              :urs_status=> @master.urs_status,
                              :urs_email=> @master.urs_email,
                              :status_code=> @master.status_code})
    respond_to do |format|
      if @master.save
        Mam::MasterUr.where("master_id = ?", params[:temp_master_id]).each do |t|
          t.update_attribute(:master_id, @master.id)
        end
        format.html { redirect_to({:action=>"show", :id => @master.id}, :notice =>t(:successfully_created)) }
        format.xml  { render :xml => @master, :status => :created, :location => @master }
      else
        @master_ur = Mam::MasterUr.new()
        @temp_master_id = params[:temp_master_id]
        format.html { render :action => "new_urs",:layout => "application_full" }
        format.xml  { render :xml => @master.errors, :status => :unprocessable_entity }
      end
    end
  end

  def add_ur
    m = Mam::MasterUr.new({:master_id => params[:master_id], :responsibility => params[:mam_master_ur][:responsibility],
                           :action => params[:mam_master_ur][:action],
                             :start_date => params[:start_date],:end_date => params[:end_date],
                             :remark => params[:mam_master_ur][:remark]})
    m.save
    respond_to do |format|
      format.js do
        responds_to_parent do
          @master_id = params[:master_id]
            render :add_ur_js do |page|
          end
        end
      end
    end
  end

  def delete_ur
    master_ur = Mam::MasterUr.find(params[:id])
    master_ur.destroy

    respond_to do |format|
      @master_id = params[:master_id]
      format.js {render :delete_ur_js}
    end
  end

  def add_item
    m = Mam::MasterItem.new(params[:mam_master_item])
    m.master_id = params[:master_id]
    m.save
    respond_to do |format|
      format.js do
        responds_to_parent do
          @master_id = params[:master_id]
            render :add_item_js do |page|
          end
        end
      end
    end
  end

  def create_reply
    master_reply = Mam::MasterReply.new(params[:mam_master_reply])
    master = Mam::Master.find(params[:master_id])
    if master.support_person_id == Irm::Person.current.id
      master_reply.reply_type = 'SUPPORTER_REPLY'
    elsif master.submitted_by == Irm::Person.current.id
      master_reply.reply_type = 'CUSTOMER_REPLY'
    else
      master_reply.reply_type = 'OTHER_REPLY'
    end
    master_reply.master_id = params[:master_id]
    master_reply.reply_number = Irm::Sequence.nextval("MAM::ReplyNumber")

    respond_to do |format|
      if master_reply.save
        format.html { redirect_to({:action=>"show", :id => params[:master_id]}, :notice =>t(:successfully_created)) }
      else
        format.html { redirect_to({:action=>"show", :id => params[:master_id]}, :notice =>t(:successfully_created)) }
      end
    end
  end

  def get_item_data
    if params[:real_master_id]
      master_items_scope = Mam::MasterItem.select_all.with_sng.with_template.with_department.with_business_unit.with_inv_account.with_inv_sub_account.where("master_id = ? OR master_id = ?", params[:master_id], params[:real_master_id])
    else
      master_items_scope = Mam::MasterItem.select_all.with_sng.with_template.with_department.with_business_unit.with_inv_account.with_inv_sub_account.where("master_id = ?", params[:master_id])
    end
    master_items_scope,count = paginate(master_items_scope)
    respond_to do |format|
      format.html  {
        @show_form = true if params[:show_form]
        @master_id = params[:master_id]
        @datas = master_items_scope
        @count = count
      }
    end
  end

  def delete_item
    master_item = Mam::MasterItem.find(params[:id])
    master_item.destroy

    respond_to do |format|
      @master_id = params[:master_id]
      format.js {render :delete_item_js}
    end
  end

  def get_ur_data
    if params[:real_master_id]
      master_urs_scope = Mam::MasterUr.select_all.with_action.with_responsibility.where("master_id = ? OR master_id = ?", params[:master_id], params[:real_master_id])
    else
      master_urs_scope = Mam::MasterUr.select_all.with_action.with_responsibility.where("master_id = ?", params[:master_id])
    end
    master_urs_scope,count = paginate(master_urs_scope)
    respond_to do |format|
      format.html  {
        @show_form = true if params[:show_form]
        @master_id = params[:master_id]
        @datas = master_urs_scope
        @count = count
      }
    end
  end

  # GET /incident_rsolr_searchequests/1/edit
  def edit

  end



  def get_data
    return_columns = [:master_number,
                      :master_type,
                      :title,
                      :master_type_label,
                      :system_id,
                      :system_id_label,
                      :submitted_by,
                      :submitted_by_label,
                      :support_group_id,
                      :support_group_id_label,
                      :support_person_id,
                      :master_status_label,
                      :master_status,
                      :support_person_id_label]
    bo = Irm::BusinessObject.where(:business_object_code => "MAM_MASTERS").first

    system_id_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id, "system_id")
    master_type_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id, "master_type")
    submitted_by_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id, "submitted_by")
    supporter_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id, "support_person_id")
    status_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id, "master_status")
    masters_scope = eval(bo.generate_query_by_attributes(return_columns, true))

    #masters_scope = masters_scope.match_value("#{Mam::Master.table_name}.title", params[:title])
    masters_scope = masters_scope.match_value("#{Mam::Master.table_name}.master_number", params[:master_number])
    masters_scope = masters_scope.match_value("#{master_type_table_alias}.meaning", params[:master_type_label])
    masters_scope = masters_scope.match_value("#{system_id_table_alias}.system_name", params[:system_id_label])
    masters_scope = masters_scope.match_value("#{submitted_by_table_alias}.full_name",params[:submitted_by_label])
    masters_scope = masters_scope.match_value("#{supporter_table_alias}.full_name", params[:support_person_id_label])
    masters_scope = masters_scope.match_value("#{status_table_alias}.meaning", params[:master_status_label])
    
    if params[:order_name]
      order_value = params[:order_value] ? params[:order_value] : "DESC"
      if params[:order_name].eql?("master_number")
        masters_scope = masters_scope.order("(#{params[:order_name]}+0) #{order_value}")
      else
        masters_scope = masters_scope.order("#{params[:order_name]} #{order_value}")
      end
    else
      masters_scope = masters_scope.order("updated_at DESC")
    end

    respond_to do |format|
      format.json {
        masters, count = paginate(masters_scope)
        render :json => to_json(masters.to_grid_json(return_columns, count))
      }
      format.html {
        @datas, @count = paginate(masters_scope)
      }
      format.xls {
        masters = data_filter(masters_scope)
        send_data(data_to_xls(masters,
                              [{:key => "master_number", :label => "No."},
                               {:key => "master_type", :label => "Master Type"},
                               {:key => "system_id_label", :label => "System"},
                               {:key => "submitted_by_label", :label => "Requester"},
                               {:key => "support_person_id_label", :label => "Supporter"},
                               {:key => "master_status_label", :label => "Status"}]
                  ))
      }
    end
  end

  def update_assign
    master = Mam::Master.find(params[:master_id])

    if params[:next_person].present?
      master.update_attribute(:support_person_id, Irm::Person.current.id)
      master_reply = Mam::MasterReply.new(params[:mam_master_reply])
      master_reply.reply_type = 'ASSIGN'
      master_reply.reply_content = 'Receive'
      master_reply.master_id = params[:master_id]
      master_reply.reply_number = Irm::Sequence.nextval("MAM::ReplyNumber")
      master_reply.save
    else
      if params[:support_group_id].present?
        master.update_attribute(:support_group_id, params[:support_group_id])
        master.update_attribute(:support_person_id, params[:support_person_id])
      end
      master_reply = Mam::MasterReply.new(params[:mam_master_reply])
      master_reply.reply_type = 'ASSIGN'
      master_reply.reply_content = 'Assign'
      master_reply.master_id = params[:master_id]
      master_reply.reply_number = Irm::Sequence.nextval("MAM::ReplyNumber")
      master_reply.save
    end

    master.update_attribute(:master_status, "MAM_PROCESSING") if master.master_replies.where("reply_type = ?", 'ASSIGN').size <= 1
    Mam::MasterStatus.create({:master_number => master.master_number,
                              :master_type => master.master_type,
                              :category => master.category,
                              :system_id => master.system_id,
                              :submitted_by => master.submitted_by,
                              :master_status => master.master_status,
                              :support_group_id =>master.support_group_id,
                              :support_person_id => master.support_person_id,
                              :remark => master.remark,
                              :contact=> master.contact,
                              :contact_number=> master.contact_number,
                              :urs_user_name=> master.urs_user_name,
                              :urs_start_date=> master.urs_start_date,
                              :urs_end_date=> master.urs_end_date,
                              :urs_person=> master.urs_person,
                              :urs_description=> master.urs_description,
                              :urs_status=> master.urs_status,
                              :urs_email=> master.urs_email,
                              :status_code=> master.status_code})

    respond_to do |format|
        format.html { redirect_to({:action=>"show", :id => params[:master_id]}, :notice =>t(:successfully_created)) }
    end
  end

  def update_status
    master = Mam::Master.find(params[:mam_master_reply][:master_id]) if params[:mam_master_reply]
    master = Mam::Master.find(params[:master_id]) if params[:master_id]

    master.update_attribute(:master_status, params[:mam_master][:master_status]) if params[:mam_master].present?
    master.update_attribute(:master_status, params[:next_status]) if params[:next_status].present?

    Mam::MasterStatus.create({:master_number => master.master_number,
                              :master_type => master.master_type,
                              :category => master.category,
                              :system_id => master.system_id,
                              :submitted_by => master.submitted_by,
                              :master_status => master.master_status,
                              :support_group_id =>master.support_group_id,
                              :support_person_id => master.support_person_id,
                              :remark => master.remark,
                              :contact=> master.contact,
                              :contact_number=> master.contact_number,
                              :urs_user_name=> master.urs_user_name,
                              :urs_start_date=> master.urs_start_date,
                              :urs_end_date=> master.urs_end_date,
                              :urs_person=> master.urs_person,
                              :urs_description=> master.urs_description,
                              :urs_status=> master.urs_status,
                              :urs_email=> master.urs_email,
                              :status_code=> master.status_code})

    respond_to do |format|
      format.html { redirect_to({:action=>"show", :id => params[:master_id]}, :notice =>t(:successfully_created)) }
    end
  end
end
