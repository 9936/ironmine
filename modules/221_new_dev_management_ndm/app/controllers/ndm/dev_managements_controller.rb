class Ndm::DevManagementsController < ApplicationController
  def index
    @project_params = params[:project_params] if params[:project_params]

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end

  def sindex
    @project_params = params[:project_params] if params[:project_params]

    respond_to do |format|
      #format.html { render :layout => "application_full"}
      format.html { render :action => "index",  :layout => "application_full"}
    end
  end

  def show
    language = I18n.locale
    @dev_management = Ndm::DevManagement.select_all.find(params[:id])
    #@dev_phases = Ndm::DevPhase.with_phase_status(language).with_template.
    #    where("dev_management_id = ?", @dev_management.id).
    #    order("display_sequence ASC, created_at ASC")

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end

  def new
    @dev_management = Ndm::DevManagement.new

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end

  def edit
    @dev_management = Ndm::DevManagement.with_branch(I18n.locale).select_all.find(params[:id])
    #@dev_phases = Ndm::DevPhase.with_template.
    #    where("dev_management_id = ?", @dev_management.id).
    #    order("display_sequence ASC, created_at ASC")

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end

  def create
    @dev_management = Ndm::DevManagement.new(params[:ndm_dev_management])
    #@dev_management.no = Irm::Sequence.nextval(@dev_management.branch)
    respond_to do |format|
      if @dev_management.save
        @dev_management.update_dev_status
        #@dev_management.update_trigger
        if params[:save_back]
          format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        else params[:save_continue]
          format.html { redirect_to({:action => "edit", :id => @dev_management.id}, :notice => t(:successfully_updated)) }
        end
      else
        format.html { render :action => "new",:layout => "application_full" }
      end
    end
  end

  def update
    @dev_management = Ndm::DevManagement.find(params[:id])
    #dev_phases = params[:dev_phase]

    respond_to do |format|
      if @dev_management.update_attributes(params[:ndm_dev_management])
        @dev_management.update_dev_status
        #dev_phases.each do |dp|
        #  Ndm::DevPhase.find(dp[0]).update_attributes(dp[1])
        #end if dev_phases
        #@dev_management.update_trigger
        if params[:save_back]
          format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        else params[:save_continue]
          format.html { redirect_to({:action => "edit", :id => params[:id]}, :notice => t(:successfully_updated)) }
        end
      else
        format.html { render :action => "edit",:layout => "application_full" }
      end
    end
  end

  def destroy
    @dev_management = Ndm::DevManagement.find(params[:id])
    @dev_management.destroy

    respond_to do |format|
      format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
      format.xml { head :ok }
    end
  end


  def get_data
    language = I18n.locale

    dev_management_scope = Ndm::DevManagement.
        with_method(language).
        with_project_relation(Irm::Person.current.id).
        with_dev_difficulty(language).
        with_dev_type(language).
        with_priority(language).
        with_branch(language).
        with_status(language, "gd_status").
        with_status(language, "fd_status").
        with_status(language, "fdr_status").
        with_status(language, "td_status").
        with_status(language, "co_status").
        with_status(language, "te_status").
        with_status(language, "si_status").
        with_status(language, "at_status").
        with_status(language, "go_status").
        joins("LEFT OUTER JOIN #{Irm::Person.table_name} gd_p ON gd_p.id = #{Ndm::DevManagement.table_name}.gd_owner").
        select("gd_p.full_name gd_owner_name").
        joins("LEFT OUTER JOIN #{Irm::Person.table_name} fd_p ON fd_p.id = #{Ndm::DevManagement.table_name}.fd_owner").
        select("fd_p.full_name fd_owner_name").
        joins("LEFT OUTER JOIN #{Irm::Person.table_name} fdr_p ON fdr_p.id = #{Ndm::DevManagement.table_name}.fdr_owner").
        select("fdr_p.full_name fdr_owner_name").
        joins("LEFT OUTER JOIN #{Irm::Person.table_name} td_p ON td_p.id = #{Ndm::DevManagement.table_name}.td_owner").
        select("td_p.full_name td_owner_name").
        joins("LEFT OUTER JOIN #{Irm::Person.table_name} co_p ON co_p.id = #{Ndm::DevManagement.table_name}.co_owner").
        select("co_p.full_name co_owner_name").
        joins("LEFT OUTER JOIN #{Irm::Person.table_name} te_p ON te_p.id = #{Ndm::DevManagement.table_name}.te_owner").
        select("te_p.full_name te_owner_name").
        joins("LEFT OUTER JOIN #{Irm::Person.table_name} si_p ON si_p.id = #{Ndm::DevManagement.table_name}.si_owner").
        select("si_p.full_name si_owner_name").
        joins("LEFT OUTER JOIN #{Irm::Person.table_name} at_p ON at_p.id = #{Ndm::DevManagement.table_name}.at_owner").
        select("at_p.full_name at_owner_name").
        joins("LEFT OUTER JOIN #{Irm::Person.table_name} go_p ON go_p.id = #{Ndm::DevManagement.table_name}.go_owner").
        select("go_p.full_name go_owner_name").
        with_member(Irm::Person.current.id).
        select_all.
        order("branch ASC, (no + 0) ASC")

    dev_management_scope = dev_management_scope.
        where("#{Ndm::DevManagement.table_name}.project IN (?)",
              params[:project_params][:project_id]) if params[:project_params] && params[:project_params][:project_id].first.present?

    dev_management_scope = dev_management_scope.
        where("CONCAT(vbranch.meaning, '-', #{Ndm::DevManagement.table_name}.no) LIKE ?",
              '%' + params[:project_params][:no] + '%') if params[:project_params] && params[:project_params][:no].present?

    dev_management_scope = dev_management_scope.
        where("#{Ndm::DevManagement.table_name}.name LIKE ?",
              '%' + params[:project_params][:name] + '%') if params[:project_params] && params[:project_params][:name].present?

    dev_management_scope = dev_management_scope.
        where("#{Ndm::DevManagement.table_name}.dev_status LIKE ?",
              '%' + params[:project_params][:dev_status] + '%') if params[:project_params] && params[:project_params][:dev_status].present?

    dev_management_scope = dev_management_scope.
        where("vtype.meaning LIKE ?",
              '%' + params[:project_params][:dev_type] + '%') if params[:project_params] && params[:project_params][:dev_type].present?

    dev_management_scope = dev_management_scope.
        where("vpriority.meaning LIKE ?",
              '%' + params[:project_params][:priority] + '%') if params[:project_params] && params[:project_params][:priority].present?

    dev_management_scope = dev_management_scope.
        where("vmethod.meaning LIKE ?",
              '%' + params[:project_params][:method] + '%') if params[:project_params] && params[:project_params][:method].present?

    dev_management_scope = dev_management_scope.
        where("vdifficulty.meaning LIKE ?",
              '%' + params[:project_params][:dev_difficulty] + '%') if params[:project_params] && params[:project_params][:dev_difficulty].present?

    begin
    dev_management_scope = dev_management_scope.
        where("date_format(#{Ndm::DevManagement.table_name}.require_date, '%Y-%m-%d') >= ?",
              Date.strptime("#{params[:project_params][:date_from]}", '%Y-%m-%d').strftime("%Y-%m-%d")) if params[:project_params] && params[:project_params][:date_from].present?
    rescue
      nil
    end

    begin
    dev_management_scope = dev_management_scope.
        where("date_format(#{Ndm::DevManagement.table_name}.require_date, '%Y-%m-%d') <= ?",
              Date.strptime("#{params[:project_params][:date_to]}", '%Y-%m-%d').strftime("%Y-%m-%d")) if params[:project_params] && params[:project_params][:date_to].present?
    rescue
      nil
    end

    dev_managements, count = paginate(dev_management_scope)
    respond_to do |format|
      format.html {
        @datas = dev_managements
        @count = count
      }
      format.json { render :json => to_jsonp(dev_managements.to_grid_json([:name, :description, :status], count)) }
    end
  end

  def create_phase
    dp = Ndm::DevPhase.new({:dev_management_id => params[:dev_management_id],
                       :dev_phase_template_id => params[:dev_phase_template_id],
                       :display_sequence => 10})
    respond_to do |format|
      if dp.save
        dp.dev_management.update_trigger
        format.html { redirect_to({:action => "edit", :id => params[:dev_management_id]}, :notice => t(:successfully_created)) }
      else
        format.html { redirect_to({:action => "edit", :id => params[:dev_management_id]}) }
      end
    end
  end

  def edit_phase_sequence
    @dev_management = Ndm::DevManagement.find(params[:id])
    @dev_phases = Ndm::DevPhase.with_template.where("dev_management_id = ?", @dev_management.id).order("display_sequence ASC, created_at ASC")

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end

  def update_phase_sequence
    @dev_management = Ndm::DevManagement.find(params[:id])
    dev_phases = params[:dev_phase]

    respond_to do |format|
      dev_phases.each do |dp|
        Ndm::DevPhase.find(dp[0]).update_attributes(dp[1])
      end if dev_phases
      @dev_management.update_trigger
      format.html { redirect_to({:action => "show", :id => params[:id]}, :notice => t(:successfully_updated)) }
    end
  end

  def phase_edit
    language = I18n.locale
    @phase_code = params[:phase_code]
    @dev_management = Ndm::DevManagement.select_all.
        with_method(language).
        with_project_relation(Irm::Person.current.id).
        with_dev_difficulty(language).
        with_dev_type(language).
        with_priority(language).find(params[:dev_management_id])

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end

  def phase_update
    @dev_management = Ndm::DevManagement.find(params[:id])

    respond_to do |format|
      if @dev_management.update_attributes(params[:ndm_dev_management])
        @dev_management.update_dev_status
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
      else
        format.html { render :action => "phase_edit" }
      end
    end
  end

  def import_excel
    @dev_management = Ndm::DevManagement.new

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end

  def import_excel_create
    #从xls导入数据
    #if params[:files]&&params[:files].any?

    @project = Ndm::Project.find(params[:ndm_dev_management][:project])

    files=[]
    if params[:file].present?
      files << Irm::AttachmentVersion.create({:source_id => @project.id,
                                              :source_type => Ndm::Project.name,
                                              :data => params[:file],
                                              :description => nil})
    end
    error_log=parse_from_xls(files, @project.id)
    respond_to do |format|
      if error_log.blank?
        if params[:save_back]
          format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        elsif params[:save_continue]
          format.html { redirect_to({:action => "import_excel"}, :notice => t(:successfully_updated)) }
        end
      else
        #不符合凭证模板
        if error_log.keys.include?("mismatch")
          show_log=error_log.values.join("")
        else #存在为空的必输项
          show_log= "ERROR 1"
          show_log << error_log.keys.join(",")
          show_log<< "ERROR 2"
        end
        puts("+++++++++++++++++++++++++++ error log" + error_log.to_json)
        @dev_management = Ndm::DevManagement.new
        format.html { render :action => "import_excel",:layout => "application_full" }
      end
    end
  end

  private
  def parse_from_xls(files, project_id)
    error_log={}
    ndm_project = Ndm::Project.where("id = ?", project_id)
    return error_log["project_error"] = "Project Error" unless ndm_project.any?

    #读取xls内容
    attachment = Irm::AttachmentVersion.find(files.first.id)
    xls_file_path = attachment.data.path
    return unless File.exists?(xls_file_path)
    puts("++++++++++++++++++++++++++++++++++++++++++" + xls_file_path)
    require 'spreadsheet'
    book = Spreadsheet::open(xls_file_path)
    sheet1 = book.worksheet 0
    title_seq={}
    sheet1.each_with_index do |row,row_num|
      #获取表头顺序
      if row_num==3
        row.each_with_index do |d, index|
          if d.eql?("Branch")
            title_seq["branch"]=index
          elsif d.eql?("Module")
            title_seq["module"]=index
          elsif d.eql?("No")
            title_seq["no"]=index
          elsif d.eql?("Gap No.")
            title_seq["gap_no"]=index
          elsif d.eql?("Name")
            title_seq["name"]=index
          elsif d.eql?("Description")
            title_seq["description"]=index
          elsif d.eql?("Priority")
            title_seq["priority"]=index
          elsif d.eql?("Current Status")
            title_seq["current_status"]=index
          elsif d.eql?("Type")
            title_seq["type"]=index
          elsif d.eql?("Method")
            title_seq["method"]=index
          elsif d.eql?("Difficulty")
            title_seq["difficulty"]=index

          elsif d.eql?("GD Owner")
            title_seq["gd_owner"]=index
          elsif d.eql?("GD Status")
            title_seq["gd_status"]=index
          elsif d.eql?("GD Plan Start Date")
            title_seq["gd_plan_start"]=index
          elsif d.eql?("GD Plan End Date")
            title_seq["gd_plan_end"]=index

          elsif d.eql?("FD Owner")
            title_seq["fd_owner"]=index
          elsif d.eql?("FD Status")
            title_seq["fd_status"]=index
          elsif d.eql?("FD Plan Start Date")
            title_seq["fd_plan_start"]=index
          elsif d.eql?("FD Plan End Date")
            title_seq["fd_plan_end"]=index

          elsif d.eql?("FDR Owner")
            title_seq["fdr_owner"]=index
          elsif d.eql?("FDR Status")
            title_seq["fdr_status"]=index
          elsif d.eql?("FDR Plan End Date")
            title_seq["fdr_plan_end"]=index

          elsif d.eql?("TD Owner")
            title_seq["td_owner"]=index
          elsif d.eql?("TD Status")
            title_seq["td_status"]=index
          elsif d.eql?("TD Plan End Date")
          title_seq["td_plan_end"]=index

          elsif d.eql?("CO Owner")
            title_seq["co_owner"]=index
          elsif d.eql?("CO Status")
            title_seq["co_status"]=index
          elsif d.eql?("CO Plan End Date")
            title_seq["co_plan_end"]=index

          elsif d.eql?("TE Owner")
            title_seq["te_owner"]=index
          elsif d.eql?("TE Status")
            title_seq["te_status"]=index
          elsif d.eql?("TE Plan End Date")
            title_seq["te_plan_end"]=index

          elsif d.eql?("SI Owner")
            title_seq["si_owner"]=index
          elsif d.eql?("SI Status")
            title_seq["si_status"]=index
          elsif d.eql?("SI Plan End Date")
            title_seq["si_plan_end"]=index

          elsif d.eql?("AT Owner")
            title_seq["at_owner"]=index
          elsif d.eql?("AT Status")
            title_seq["at_status"]=index
          elsif d.eql?("AT Plan End Date")
            title_seq["at_plan_end"]=index

          elsif d.eql?("GO Owner")
            title_seq["go_owner"]=index
          elsif d.eql?("GO Status")
            title_seq["go_status"]=index
          elsif d.eql?("GO Plan End Date")
            title_seq["go_plan_end"]=index
          end
          puts("++++++++++++++++++++++++++++++++++++++++++ title seq" + title_seq.to_json)
        end
        #不符合要求模板不予导入
        if title_seq.size != 40
          puts("++++++++++++++++++++++++++++++++++++++++++ title size" + title_seq.size.to_s)
          error_log["mismatch"] = "Excel Template Mismatch"
          return error_log
        end
      elsif row_num > 3
        puts("+++++++++++++++++++++++++++++=1")
        #import data to tmp table
        break if row[title_seq["module"]].eql?("END")
        puts("+++++++++++++++++++++++++++++=2")
        next if row[title_seq["gap_no"]].blank?
        puts("+++++++++++++++++++++++++++++=3")
        tdm = Ndm::TmpDevManagement.new({
                                     :project => project_id,
                                     :no => row[title_seq["gap_no"]].to_i,
                                     :name => row[title_seq["name"]],
                                     :branch => row[title_seq["branch"]],
                                     :description => row[title_seq["description"]],
                                     :priority => row[title_seq["priority"]],
                                     :dev_status => row[title_seq["current_status"]],
                                     :dev_type => row[title_seq["type"]],
                                     :method => row[title_seq["method"]],
                                     :module => row[title_seq["module"]],
                                     :dev_difficulty => row[title_seq["difficulty"]],

                                     :gd_owner => row[title_seq["gd_owner"]],
                                     :gd_status => row[title_seq["gd_status"]],
                                     :gd_plan_start => row[title_seq["gd_plan_start"]],
                                     :gd_plan_end => row[title_seq["gd_plan_end"]],

                                     :fd_owner => row[title_seq["fd_owner"]],
                                     :fd_status => row[title_seq["fd_status"]],
                                     :fd_plan_start => row[title_seq["fd_plan_start"]],
                                     :fd_plan_end => row[title_seq["fd_plan_end"]],

                                     :fdr_owner => row[title_seq["fdr_owner"]],
                                     :fdr_status => row[title_seq["fdr_status"]],
                                     :fdr_plan_end => row[title_seq["fdr_plan_end"]],

                                     :td_owner => row[title_seq["td_owner"]],
                                     :td_status => row[title_seq["td_status"]],
                                     :td_plan_end => row[title_seq["td_plan_end"]],

                                     :co_owner => row[title_seq["co_owner"]],
                                     :co_status => row[title_seq["co_status"]],
                                     :co_plan_end => row[title_seq["co_plan_end"]],

                                     :te_owner => row[title_seq["te_owner"]],
                                     :te_status => row[title_seq["te_status"]],
                                     :te_plan_end => row[title_seq["te_plan_end"]],

                                     :si_owner => row[title_seq["si_owner"]],
                                     :si_status => row[title_seq["si_status"]],
                                     :si_plan_end => row[title_seq["si_plan_end"]],

                                     :at_owner => row[title_seq["at_owner"]],
                                     :at_status => row[title_seq["at_status"]],
                                     :at_plan_end => row[title_seq["at_plan_end"]],

                                     :go_owner => row[title_seq["go_owner"]],
                                     :go_status => row[title_seq["go_status"]],
                                     :go_plan_end => row[title_seq["go_plan_end"]],

                                     :source_id => attachment.id,
                                     :import_status => 'N'
                                  })
        tdm.save
      end
    end
    Delayed::Job.enqueue(Ndm::Jobs::ImportExcelJob.new(attachment.id))
    error_log
  end
end
