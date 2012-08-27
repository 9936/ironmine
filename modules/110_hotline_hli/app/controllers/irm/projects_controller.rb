class Irm::ProjectsController < ApplicationController
  def new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def add_person
    @person = Irm::Person.new
    @project_code = params[:project_code]
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create_person
    @person = Irm::Person.new(params[:irm_person])
    project_code = params[:project_code]

    organization = Irm::Organization.where(:short_name => project_code).first
    @person.organization_id = organization.id

    respond_to do |format|
      if @person.save
        external_system = Irm::ExternalSystem.where(:external_system_code => project_code).first
        group = Irm::Group.where(:code => "USER").first

        #将人员加入用户组，以及添加项目对应的应用系统为可访问应用系统
        Irm::GroupMember.create(:group_id => group.id, :person_id => @person.id) unless Irm::GroupMember.where(:group_id => group.id).where(:person_id => @person.id).any?
        Irm::ExternalSystemPerson.create(:external_system_id => external_system.id, :person_id => @person.id) unless Irm::ExternalSystemPerson.where(:external_system_id => external_system.id).where(:person_id => @person.id).any?

        format.html { redirect_to({:action=>"show", :id => organization.id},:notice => (t :successfully_created))}
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        @project_code = params[:project_code]
        format.html { render "add_person" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit_person

  end

  def update_person

  end

  def create
    auto_code = Irm::Sequence.nextval(Irm::Organization.name)
    #创建组织
    organization = Irm::Organization.new(:parent_org_id => Irm::Organization.where("short_name = ?", "HAND_SUPPORT_CUSTOMER").first.id,
                                         :opu_id => Irm::Person.current.opu_id,
                                         :short_name => auto_code,
                                         :hotline => 'Y',
                                         :not_auto_mult => true)
    organization.organizations_tls.build(:language=>'zh',
                                         :source_lang=>'en',
                                         :name=> params[:project_name],
                                         :description=> params[:project_description])
    organization.organizations_tls.build(:language=>'en',
                                         :source_lang=>'en',
                                         :name=> params[:project_name],
                                         :description=> params[:project_description])

    #创建应用系统
    external_system = Irm::ExternalSystem.new(:opu_id => Irm::Person.current.opu_id,
                                              :hotline_flag => params[:hotline],
                                              :external_system_code => auto_code,
                                              :external_ip_address => "000.000.000.000",
                                              :not_auto_mult=>true)
    external_system.external_systems_tls.build(:language => 'zh',
                                               :source_lang => 'en',
                                               :system_name => params[:project_name],
                                               :system_description => params[:project_description])
    external_system.external_systems_tls.build(:language => 'en',
                                               :source_lang => 'en',
                                               :system_name => params[:project_name],
                                               :system_description => params[:project_description])

    #创建项目二级运维组
    group = Irm::Group.new(:opu_id => Irm::Person.current.opu_id,
                           :parent_group_id => Irm::Group.where("code = ?", "EBS_HELP_DESK").first.id,
                           :code => auto_code,
                           :not_auto_mult => true)
    group.groups_tls.build(:language => 'zh',
                           :source_lang => 'en',
                           :name => params[:project_name],
                           :description => params[:project_description])
    group.groups_tls.build(:language => 'en',
                           :source_lang => 'en',
                           :name => params[:project_name],
                           :description => params[:project_description])
    @errors = ""
    bo = Irm::BusinessObject.where(:bo_model_name => 'Icm::IncidentRequest').first
    respond_to do |format|
      if organization.valid?() && external_system.valid?() && group.valid?()
        organization.save
        external_system.save
        group.save
        #support group
        t_group = Icm::SupportGroup.new(:opu_id => Irm::Person.current.opu_id,
                                   :assignment_process_code => "NEVER_ASSIGN",
                                   :group_id => group.id,
                                   :vendor_flag => Irm::Constant::SYS_NO,
                                   :oncall_flag => Irm::Constant::SYS_YES)
        t_group.save
        #create share rule
        t_share = Irm::DataShareRule.new(:opu_id => Irm::Person.current.opu_id,:business_object_id => bo.id, :access_level => '2',:code => auto_code,
                                         :rule_type => 'BASE_ON_REPORT_OWNER', :source_type => 'IRM__ORGANIZATION',
                                         :source_id => organization.id,:target_type => 'IRM__GROUP', :target_id => group.id,
                                         :status_code=>'ENABLED',:not_auto_mult=>true)
        t_share.data_share_rules_tls.build(:opu_id => Irm::Person.current.opu_id, :language=>'zh',:source_lang=>'en',
                                           :name=>params[:project_name],:status_code=>'ENABLED',:description=>params[:project_description])
        t_share.data_share_rules_tls.build(:opu_id => Irm::Person.current.opu_id, :language=>'en',:source_lang=>'en',
                                           :name=>params[:project_name],:status_code=>'ENABLED',:description=>params[:project_description])
        t_share.save

        t_share2 = Irm::DataShareRule.new(:opu_id => Irm::Person.current.opu_id,:business_object_id => bo.id, :access_level => '2',:code => auto_code + "_FARTHER",
                                         :rule_type => 'BASE_ON_REPORT_OWNER', :source_type => 'IRM__ORGANIZATION',
                                         :source_id => organization.id,:target_type => 'IRM__GROUP', :target_id => Irm::Group.where("code = ?", "EBS_HELP_DESK").first.id,
                                         :status_code=>'ENABLED',:not_auto_mult=>true)
        t_share2.data_share_rules_tls.build(:opu_id => Irm::Person.current.opu_id, :language=>'zh',:source_lang=>'en',
                                           :name=>params[:project_name],:status_code=>'ENABLED',:description=>params[:project_description])
        t_share2.data_share_rules_tls.build(:opu_id => Irm::Person.current.opu_id, :language=>'en',:source_lang=>'en',
                                           :name=>params[:project_name],:status_code=>'ENABLED',:description=>params[:project_description])
        t_share2.save

        if params[:next] && params[:next] == "add_person"
          format.html { redirect_to({:controller => "irm/projects",:action => "add_person", :project_code => auto_code})}
        else

        end
      else
        @errors = organization.errors.any? ? organization.errors : external_system.errors.any? ? external_system.errors : group.errors.any? ? group.errors : ""
        format.html { render "new" }
      end
    end
  end

  def edit
    @project_code = params[:project_code]
    @project = Irm::Organization.multilingual.
            joins(",#{Irm::ExternalSystem.view_name} es").
            joins(",#{Irm::ExternalSystem.table_name} esa").
            joins(",#{Irm::Group.view_name} gp").
            joins(",#{Irm::OrganizationsTl.table_name} ot").
            where("ot.organization_id = #{Irm::Organization.table_name}.id").
            where("es.external_system_code = #{Irm::Organization.table_name}.short_name").
            where("gp.code = #{Irm::Organization.table_name}.short_name").
            where("es.language = ?", I18n.locale).
            where("gp.language = ?", I18n.locale).
            where("ot.language = ?", I18n.locale).
            where("esa.id = es.id").
            where("#{Irm::Organization.table_name}.short_name = ?", params[:project_code]).
            select("#{Irm::Organization.table_name}.id id, #{Irm::Organization.table_name}.short_name short_name, ot.name org_name, #{Irm::Organization.table_name}.status_code project_status").
            select("es.id system_id, es.system_name system_name, esa.hotline_flag hotline, es.system_description project_description").
            select("gp.id group_id, gp.name group_name").first
  end

  def update
    organization = Irm::Organization.where("short_name=?", params[:project_code]).first
    external_system = Irm::ExternalSystem.where("external_system_code = ?", params[:project_code]).first
    group = Irm::Group.where("code = ?", params[:project_code]).first
    respond_to do |format|
      organization.update_attributes(:name => params[:project_name], :description => params[:project_description])
      external_system.update_attributes(:system_name => params[:project_name],
                                        :system_description => params[:project_description],
                                        :hotline_flag => params[:hotline])
      group.update_attributes(:name => params[:project_name], :description => params[:project_description])
      format.html { redirect_to({:action=>"show", :id => organization.id},:notice => (t :successfully_updated)) }
    end
  end

  def get_data
    projects_scope = Irm::Organization.multilingual.
        joins(",#{Irm::ExternalSystem.view_name} es").
        joins(",#{Irm::Group.view_name} gp").
        joins(",#{Irm::OrganizationsTl.table_name} ot").
        joins(",#{Irm::ExternalSystem.table_name} esa").
        where("ot.organization_id = #{Irm::Organization.table_name}.id").
        where("es.external_system_code = #{Irm::Organization.table_name}.short_name").
        where("gp.code = #{Irm::Organization.table_name}.short_name").
        where("es.language = ?", I18n.locale).
        where("gp.language = ?", I18n.locale).
        where("ot.language = ?", I18n.locale).
        where("esa.id = es.id").
        select("#{Irm::Organization.table_name}.id id, #{Irm::Organization.table_name}.short_name short_name, ot.name org_name, #{Irm::Organization.table_name}.status_code project_status").
        select("es.id system_id, es.system_name system_name, esa.hotline_flag hotline").
        select("gp.id group_id, gp.name group_name").order("CONVERT( ot.name USING gbk ) asc")

    projects_scope = projects_scope.match_value("#{Irm::Organization.table_name}.short_name",params[:short_name])
    projects_scope = projects_scope.match_value("es.system_name",params[:system_name])
    projects_scope = projects_scope.match_value("ot.name",params[:org_name])
    projects_scope = projects_scope.match_value("gp.name",params[:group_name])

    projects,count = paginate(projects_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(projects.to_grid_json([:id, :hotline,:short_name,:org_name,:system_name,
                                                                 :group_name, :system_id,:group_id, :project_status],count))}
      format.html  {
        @datas = projects
        @count = count
      }
    end
  end

  def view_my_project

  end

  def get_myself_data
    projects_scope = Irm::Organization.multilingual.
        joins(",#{Irm::ExternalSystem.view_name} es").
        joins(",#{Irm::Group.view_name} gp").
        joins(",#{Irm::OrganizationsTl.table_name} ot").
        joins(",#{Irm::ExternalSystem.table_name} esa").
        where("ot.organization_id = #{Irm::Organization.table_name}.id").
        where("es.external_system_code = #{Irm::Organization.table_name}.short_name").
        where("gp.code = #{Irm::Organization.table_name}.short_name").
        where("es.language = ?", I18n.locale).
        where("gp.language = ?", I18n.locale).
        where("ot.language = ?", I18n.locale).
        where("esa.id = es.id").
        select("#{Irm::Organization.table_name}.id id, #{Irm::Organization.table_name}.short_name short_name, ot.name org_name, #{Irm::Organization.table_name}.status_code project_status").
        select("es.id system_id, es.system_name system_name, esa.hotline_flag hotline").
        select("gp.id group_id, gp.name group_name").order("CONVERT( ot.name USING gbk ) asc")

    projects_scope = projects_scope.match_value("#{Irm::Organization.table_name}.short_name",params[:short_name])
    projects_scope = projects_scope.match_value("#{Irm::ExternalSystem.view_name}.system_name",params[:system_name])
    projects_scope = projects_scope.match_value("#{Irm::OrganizationsTl.table_name}.name",params[:org_name])
    projects_scope = projects_scope.match_value("#{Irm::Group.view_name}.name",params[:group_name])

    projects,count = paginate(projects_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(projects.to_grid_json([:id, :hotline, :short_name,:org_name,:system_name,
                                                                 :group_name, :system_id,:group_id, :project_status],count))}
    end
  end

  def show
    @project = Irm::Organization.multilingual.
            joins(",#{Irm::ExternalSystem.view_name} es").
            joins(",#{Irm::ExternalSystem.table_name} esa").
            joins(",#{Irm::Group.view_name} gp").
            joins(",#{Irm::OrganizationsTl.table_name} ot").
            where("ot.organization_id = #{Irm::Organization.table_name}.id").
            where("es.external_system_code = #{Irm::Organization.table_name}.short_name").
            where("gp.code = #{Irm::Organization.table_name}.short_name").
            where("es.language = ?", I18n.locale).
            where("gp.language = ?", I18n.locale).
            where("ot.language = ?", I18n.locale).
            where("esa.id = es.id").
            where("#{Irm::Organization.table_name}.id = ?", params[:id]).
            select("#{Irm::Organization.table_name}.id id, #{Irm::Organization.table_name}.short_name short_name, ot.name org_name, #{Irm::Organization.table_name}.status_code project_status").
            select("es.id system_id, es.system_name system_name, esa.hotline_flag hotline, es.system_description project_description").
            select("gp.id group_id, gp.name group_name").first
  end

  def get_support_person_list_data
    rel_external_system = Irm::ExternalSystem.where("external_system_code = ?", params[:project_code]).first
    rel_group = Irm::Group.where("code = ?", params[:project_code]).first
    admin_group = Irm::Group.where("code = ?", "EBS_HELP_DESK").first
    support_people_scope = Irm::Person.list_all_a.
        where("EXISTS (SELECT 1 FROM #{Irm::ExternalSystemPerson.table_name} esp WHERE esp.person_id = #{Irm::Person.table_name}.id AND esp.external_system_id = ?)", rel_external_system.id).
        where(%Q(EXISTS (SELECT 1 FROM #{Irm::GroupMember.table_name} gm WHERE gm.person_id = #{Irm::Person.table_name}.id AND gm.group_id = ?)
                OR EXISTS (SELECT 1 FROM #{Irm::GroupMember.table_name} gm WHERE gm.person_id = #{Irm::Person.table_name}.id AND gm.group_id = ?)),
              rel_group.id, admin_group.id)

    support_people_scope = support_people_scope.match_value("#{Irm::Person.table_name}.full_name",params[:person_name])
    support_people_scope = support_people_scope.match_value("#{Irm::Person.table_name}.email_address",params[:email_address])
    support_people_scope = support_people_scope.match_value("#{Irm::Organization.view_name}.name",params[:organization_name])
    support_people_scope = support_people_scope.match_value("pv.name",params[:profile_name])
    support_people_scope = support_people_scope.match_value("rv.name",params[:role_name])

    @datas, @count = paginate(support_people_scope)
    @project_code = params[:project_code]
    respond_to do |format|
      format.html  {
        render_html_data_table
      }
    end

    #format.json {render :json => to_jsonp(@support_people.to_grid_json([:system_name, :system_description, :external_system_code, :status_code], count))}
  end

  def get_customer_list_data
    rel_external_system = Irm::ExternalSystem.where("external_system_code = ?", params[:project_code]).first
    gen_group = Irm::Group.where("code = ?", "USER").first
    customer_people_scope = Irm::Person.list_all_a.
        where("EXISTS (SELECT 1 FROM #{Irm::ExternalSystemPerson.table_name} esp WHERE esp.person_id = #{Irm::Person.table_name}.id AND esp.external_system_id = ?)", rel_external_system.id).
        where("EXISTS (SELECT 1 FROM #{Irm::GroupMember.table_name} gm WHERE gm.person_id = #{Irm::Person.table_name}.id AND gm.group_id = ?)", gen_group.id)

    customer_people_scope = customer_people_scope.match_value("#{Irm::Person.table_name}.full_name",params[:person_name])
    customer_people_scope = customer_people_scope.match_value("#{Irm::Person.table_name}.email_address",params[:email_address])
    customer_people_scope = customer_people_scope.match_value("#{Irm::Organization.view_name}.name",params[:organization_name])
    customer_people_scope = customer_people_scope.match_value("pv.name",params[:profile_name])
    customer_people_scope = customer_people_scope.match_value("rv.name",params[:role_name])

    @datas, @count = paginate(customer_people_scope)
    @project_code = params[:project_code]
    respond_to do |format|
      format.html  {
        render_html_data_table
      }
    end
  end

  def remove_project_supporter
    project = Irm::Organization.multilingual.where("short_name = ?", params[:project_code]).first
    rel_external_system = Irm::ExternalSystem.where("external_system_code = ?", params[:project_code]).first
    rel_group = Irm::Group.where("code = ?", params[:project_code]).first
    esps = Irm::ExternalSystemPerson.where("person_id = ?", params[:person_id]).where("external_system_id = ?", rel_external_system.id)
    gms = Irm::GroupMember.where("person_id = ?", params[:person_id]).where("group_id = ?", rel_group.id)

    esps.each do |es|
      es.destroy
    end

    gms.each do |gm|
      gm.destroy
    end

    Irm::Person.refresh_relation_table
    respond_to do |format|
      format.html { redirect_to({:controller=>"irm/projects",:action=>"show",:id=>project.id}) }
      format.xml  { head :ok }
    end
  end

  def remove_project_customer
    project = Irm::Organization.multilingual.where("short_name = ?", params[:project_code]).first
    rel_external_system = Irm::ExternalSystem.where("external_system_code = ?", params[:project_code]).first
    rel_group = Irm::Group.where("code = ?", "USER").first
    esps = Irm::ExternalSystemPerson.where("person_id = ?", params[:person_id]).where("external_system_id = ?", rel_external_system.id)
    gms = Irm::GroupMember.where("person_id = ?", params[:person_id]).where("group_id = ?", rel_group.id)

    esps.each do |es|
      es.destroy
    end

    gms.each do |gm|
      gm.destroy
    end

    Irm::Person.refresh_relation_table
    respond_to do |format|
      format.html { redirect_to({:controller=>"irm/projects",:action=>"show",:id=>project.id}) }
      format.xml  { head :ok }
    end
  end

  def add_customer_to_project
    @project = Irm::Organization.multilingual.
            where("#{Irm::Organization.table_name}.short_name = ?", params[:project_code]).first
    @system_person = Irm::ExternalSystemPerson.new()
    @system_person.status_code = ""
  end

  def add_supporter_to_project
    @project = Irm::Organization.multilingual.
            where("#{Irm::Organization.table_name}.short_name = ?", params[:project_code]).first
    @system_person = Irm::ExternalSystemPerson.new()
    @system_person.status_code = ""
  end

  def add_supporters
    @system_person = Irm::ExternalSystemPerson.new(params[:irm_external_system_person])
    @project = Irm::Organization.multilingual.where("short_name = ?", params[:project_code]).first
    rel_external_system = Irm::ExternalSystem.where("external_system_code = ?", params[:project_code]).first
    rel_group = Irm::Group.where("code = ?", params[:project_code]).first
    admin_group = Irm::Group.where("code = ?", "EBS_HELP_DESK").first
    respond_to do |format|
      @system_person.status_code.split(",").delete_if{|i| i.blank?}.each do |id|
        check_exist_external_system_person = Irm::ExternalSystemPerson.where("person_id = ?", id).where("external_system_id = ?", rel_external_system.id)
        Irm::ExternalSystemPerson.create(:person_id => id,:external_system_id => rel_external_system.id) unless check_exist_external_system_person.any?
        check_exist_group_member = Irm::GroupMember.where("person_id = ?", id).where("group_id = ? OR group_id = ?", rel_group.id, admin_group.id)
        Irm::GroupMember.create(:group_id => rel_group.id, :person_id => id) unless check_exist_group_member.any?
      end if @system_person.status_code.present?
      Irm::Person.refresh_relation_table

      format.html { redirect_to({:controller => "irm/projects",:action=>"show",:id => @project.id}, :notice => t(:successfully_created)) }
      format.xml  { render :xml => @system_person, :status => :created}
    end
  end

  def add_customers
    @system_person = Irm::ExternalSystemPerson.new(params[:irm_external_system_person])
    @project = Irm::Organization.multilingual.where("short_name = ?", params[:project_code]).first
    rel_external_system = Irm::ExternalSystem.where("external_system_code = ?", params[:project_code]).first
    rel_group = Irm::Group.where("code = ?", "USER").first
    respond_to do |format|
      @system_person.status_code.split(",").delete_if{|i| i.blank?}.each do |id|
        check_exist_external_system_person = Irm::ExternalSystemPerson.where("person_id = ?", id).where("external_system_id = ?", rel_external_system.id)
        Irm::ExternalSystemPerson.create(:person_id => id,:external_system_id => rel_external_system.id) unless check_exist_external_system_person.any?
        check_exist_group_member = Irm::GroupMember.where("person_id = ?", id).where("group_id = ?", rel_group.id)
        Irm::GroupMember.create(:group_id => rel_group.id, :person_id => id) unless check_exist_group_member.any?
      end if @system_person.status_code.present?
      Irm::Person.refresh_relation_table

      format.html { redirect_to({:controller => "irm/projects",:action=>"show",:id => @project.id}, :notice => t(:successfully_created)) }
      format.xml  { render :xml => @system_person, :status => :created}
    end
  end

  def get_available_project_supporter_data
    rel_external_system = Irm::ExternalSystem.where("external_system_code = ?", params[:project_code]).first
    rel_group = Irm::Group.where("code = ?", params[:project_code]).first
    admin_group = Irm::Group.where("code = ?", "EBS_HELP_DESK").first
    support_people_scope = Irm::Person.list_all_a.enabled.
        where("NOT EXISTS (SELECT 1 FROM #{Irm::ExternalSystemPerson.table_name} esp WHERE esp.person_id = #{Irm::Person.table_name}.id AND esp.external_system_id = ?)", rel_external_system.id).
        where(%Q(NOT EXISTS (SELECT 1 FROM #{Irm::GroupMember.table_name} gm WHERE gm.person_id = #{Irm::Person.table_name}.id AND gm.group_id = ?)
                AND NOT EXISTS (SELECT 1 FROM #{Irm::GroupMember.table_name} gm WHERE gm.person_id = #{Irm::Person.table_name}.id AND gm.group_id = ?)), rel_group.id, admin_group.id)
    if params[:person_name] && params[:person_name].include?(" ")
      pns = params[:person_name].split(" ")
      query = ""
      pns.each do |pn|
        query << " OR " if query.present? && pn.present?
        query << "#{Irm::Person.table_name}.full_name LIKE '%#{pn}%'" if pn.present?
      end if pns
      support_people_scope = support_people_scope.where(query) if query.present?
    else
      support_people_scope = support_people_scope.match_value("#{Irm::Person.table_name}.full_name",params[:person_name])
    end
    support_people_scope = support_people_scope.match_value("#{Irm::Person.table_name}.login_name",params[:login_name])
    support_people_scope = support_people_scope.match_value("#{Irm::Person.table_name}.email_address",params[:email_address])
    support_people_scope = support_people_scope.match_value("#{Irm::Organization.view_name}.name",params[:organization_name])
    support_people_scope = support_people_scope.match_value("pv.name",params[:profile_name])
    support_people_scope = support_people_scope.match_value("rv.name",params[:role_name])
    datas, count = paginate(support_people_scope)
    @project_code = params[:project_code]
    respond_to do |format|
      format.html  {
        @datas = datas
        @count = count
      }
    end
  end

  def get_available_project_customer_data
    rel_external_system = Irm::ExternalSystem.where("external_system_code = ?", params[:project_code]).first
    #rel_group = Irm::Group.where("code = ?", "USER").first
    customer_people_scope = Irm::Person.list_all_a.enabled.
        where("NOT EXISTS (SELECT 1 FROM #{Irm::ExternalSystemPerson.table_name} esp WHERE esp.person_id = #{Irm::Person.table_name}.id AND esp.external_system_id = ?)", rel_external_system.id)
    customer_people_scope = customer_people_scope.match_value("#{Irm::Person.table_name}.first_name",params[:person_name])
    customer_people_scope = customer_people_scope.match_value("#{Irm::Person.table_name}.login_name",params[:login_name])
    customer_people_scope = customer_people_scope.match_value("#{Irm::Person.table_name}.email_address",params[:email_address])
    customer_people_scope = customer_people_scope.match_value("#{Irm::Organization.view_name}.name",params[:organization_name])
    customer_people_scope = customer_people_scope.match_value("pv.name",params[:profile_name])
    customer_people_scope = customer_people_scope.match_value("rv.name",params[:role_name])
    datas, count = paginate(customer_people_scope)
    @project_code = params[:project_code]
    respond_to do |format|
      format.html  {
        @datas = datas
        @count = count
      }
    end
  end
end
