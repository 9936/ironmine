class Cons::ConsultantsController < ApplicationController
  def index
    #@consultants = Cons::Consultants.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @consultants }
    end
  end
  def new
    @consultants = Cons::Consultants.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @consultants }
    end
  end
  def create
    consultants = Cons::Consultants.where("id <> ?", "").order(:consultants_no).last

    if consultants
      params[:cons_consultants][:consultants_no] = (consultants.consultants_no.to_i + 1).to_s
    else
      params[:cons_consultants][:consultants_no] = "3000"
    end

    @consultants = Cons::Consultants.new(params[:cons_consultants])
    puts params[:cons_consultants].inspect

    respond_to do |format|
      if Irm::Person.where("login_name = ?",params[:cons_consultants][:login_name]).length > 0
        @consultants.errors.add(:login_name,"login_name already exists").length > 0
        format.html { render "new" }
        format.xml  { render :xml => @consultants.errors, :status => :unprocessable_entity }
        format.json  { render :json => @consultants.errors}
      else
        if @consultants.save
        # if params[:next_action]
        #   if params[:next_action].eql?("add_system")
        #     format.html { redirect_to({:controller => "cons/external_system_members",:action => "new_from_person",:person_id=>@person.id, :next_action => params[:next_action]})}
        #   elsif params[:next_action].eql?("add_group")
        #     format.html { redirect_to({:controller => "irm/group_members",:action => "new_from_person",:id=>@person.id, :next_action => params[:next_action]})}
        #   end
        # else
        @person = Irm::Person.new({
                             :opu_id => "001n00012i8IyyjJakd6Om",
                             :password => params[:cons_consultants][:password],
                             :first_name => params[:cons_consultants][:cName],
                             :login_name => params[:cons_consultants][:login_name],
                             :email_address => params[:cons_consultants][:cMail],
                             :profile_id => params[:cons_consultants][:profile_id],
                             :organization_id => params[:cons_consultants][:organization_id],
                             :bussiness_phone => params[:cons_consultants][:cTelNo]
                             # :password_updated_at=> Time.now
                         })
        @person.save!
        format.html { redirect_to({:action=>"show",:id=>@consultants.id},:notice => (t :successfully_created))}
        format.xml  { render :xml => @consultants, :status => :created, :location => @consultants }
        format.json { render :json=>@consultants}
        # end

      else
        format.html { render "new" }
        format.xml  { render :xml => @consultants.errors, :status => :unprocessable_entity }
        format.json  { render :json => @consultants.errors}
      # end
        end
      end
    end
  end

  def show
    @consultants = Cons::Consultants.find(params[:id])
    # @support_group_count = Irm::GroupMember.where(:person_id=>@consultants.id).size
    respond_to do |format|
      format.json {render :json=>@consultants}
      format.html
    end
  end

  def edit
    @consultants = Cons::Consultants.find(params[:id])
  end

  def update
    @consultants = Cons::Consultants.find(params[:id])

    respond_to do |format|
      if @consultants.update_attributes(params[:cons_consultants])
        format.html { redirect_to({:action=>"show", :id=>@consultants.id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@consultants}
      else
        @error = @consultants
        format.html { render "edit" }
        format.xml  { render :xml => @consultants.errors, :status => :unprocessable_entity }
        format.json  { render :json => @consultants.errors}
      end
    end
  end



  def get_data
    @consultants = Cons::Consultants.where("id <> ?", "").with_consultants_message
    @consultants = @consultants.match_value("#{Cons::Consultants.table_name}.cNo",params[:cNo])
    @consultants = @consultants.match_value("#{Cons::Consultants.table_name}.cName",params[:cName])
    @consultants = @consultants.match_value("#{Cons::Consultants.table_name}.cMail",params[:cMail])

    @consultants,count = paginate(@consultants)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@consultants.to_grid_json([:cNo,:cName,:cType,
                                                                :cTel,:cMail,:cComment], count))}
      format.html {
        @count = count
        @datas = @consultants
      }
    end
  end
end
