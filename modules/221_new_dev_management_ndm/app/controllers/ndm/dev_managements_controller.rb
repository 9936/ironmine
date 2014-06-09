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
    @dev_management = Ndm::DevManagement.find(params[:id])
    #@dev_phases = Ndm::DevPhase.with_template.
    #    where("dev_management_id = ?", @dev_management.id).
    #    order("display_sequence ASC, created_at ASC")

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end

  def create
    @dev_management = Ndm::DevManagement.new(params[:ndm_dev_management])
    @dev_management.no = Irm::Sequence.nextval(Ndm::DevManagement.name)
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
        format.html { render :action => "new" }
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
        format.html { render :action => "edit" }
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
        with_status(language, "gd_status").
        with_status(language, "fd_status").
        with_status(language, "fdr_status").
        with_status(language, "td_status").
        with_status(language, "co_status").
        with_status(language, "te_status").
        with_status(language, "si_status").
        with_status(language, "at_status").
        with_status(language, "go_status").with_member(Irm::Person.current.id).
        select_all.
        order("(no + 0) ASC")
    dev_management_scope = dev_management_scope.
        where("#{Ndm::DevManagement.table_name}.project IN (?)",
              params[:project_params][:project_id]) if params[:project_params] && params[:project_params][:project_id].first.present?

    dev_management_scope = dev_management_scope.
        where("#{Ndm::DevManagement.table_name}.no LIKE ?",
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

  end

  def import_excel_create
    #从xls导入数据
    #if params[:files]&&params[:files].any?
    files=[]
    params[:files].values.each do |file_value|
      if file_value[:file].present?
        files << Irm::AttachmentVersion.create({:source_id => 0,
                                                :source_type => self.class.name,
                                                :data => file_value[:file],
                                                :description => file_value[:description]})
      end
    end
    error_log=parse_from_xls(files)
    respond_to do |format|
      if error_log.blank?
        format.html { redirect_to :controller => "yin/agr_coops", :action => "gl_journal_imp", :tab => "tab6", :error => 6,:notice => t(:label_yin_export_from_xls_success) }
      else
        #不符合凭证模板
        if error_log.keys.include?("mismatch")
          show_log=error_log.values.join("")
        else #存在为空的必输项
          show_log=t("label_yin_export_from_xls_failed_first")
          show_log<<error_log.keys.join(",")
          show_log<<t("label_yin_export_from_xls_failed_second")
        end
        format.html { redirect_to :controller => "yin/agr_coops", :action => "gl_journal_imp", :tab => "tab6", :error => 6, :notice => show_log }
      end
    end
  end

  private
  def parse_from_xls(files)
    error_log={}
    #读取xls内容
    files.each do |file|
      attachment = Irm::AttachmentVersion.find(file.id)
      xls_file_path = attachment.data.path
      return unless File.exists?(xls_file_path)
      require 'spreadsheet'
      book = Spreadsheet::open(xls_file_path)
      sheet1 = book.worksheet 0
      title_seq={}
      error_journal_number=""
      sheet1.each_with_index do |row,row_num|
        #获取表头顺序
        if row_num==0
          row.each_with_index do |d, index|
            if d.eql?(t("label_yin_gl_sob"))||d.eql?(t("label_yin_gl_sob_alias"))
              title_seq["set_of_book"]=index
            elsif d.eql?(t("label_yin_gl_journal_no"))
              title_seq["journal_number"]=index
            elsif d.eql?(t("label_yin_gl_balance_method"))
              title_seq["balance_method"]=index
            elsif d.eql?(t("label_yin_gl_project"))
              title_seq["project"]=index
            elsif d.eql?(t("label_yin_gl_who_made"))
              title_seq["who_made"]=index
            elsif d.eql?(t("label_yin_gl_accountant"))
              title_seq["accountant"]=index
            elsif d.eql?(t("label_yin_gl_business_date"))
              title_seq["business_date"]=index
            elsif d.eql?(t("label_yin_gl_made_date"))
              title_seq["made_date"]=index
            elsif d.eql?(t("label_yin_gl_employee"))
              title_seq["employee"]=index
            elsif d.eql?(t("label_yin_exchange_journal_group_id"))
              title_seq["coop_id"]=index
            elsif d.eql?(t("label_yin_exchange_journal_company"))
              title_seq["company"]=index
            elsif d.eql?(t("label_yin_gl_approval"))
              title_seq["who_approval"]=index
            elsif d.eql?(t("label_yin_gl_line_description"))
              title_seq["description"]=index
            elsif d.eql?(t("label_yin_gl_line_department"))
              title_seq["department"]=index
            elsif d.eql?(t("label_yin_gl_line_amount_cr"))
              title_seq["amount_cr"]=index
            elsif d.eql?(t("label_yin_gl_line_amount_dr"))
              title_seq["amount_dr"]=index
            end
          end
          #不符合要求模板不予导入
          if title_seq.size!=16
            error_log["mismatch"]=t("label_yin_export_from_xls_failed_mismatch")
            return error_log
          end
          #创建Yin::GlJournalHeader与Yin::GlJournalLine
        else
          #若有保存失败凭证行,绕过该凭证所有行
          next if error_journal_number.eql?(row[title_seq["journal_number"]])
          #凭证字号唯一
          journal_header=Yin::GlJournalHeader.where(:journal_number => row[title_seq["journal_number"]]).first
          if journal_header
            if row[title_seq["amount_cr"]] || row[title_seq["amount_dr"]]
              gl_journal_line = Yin::GlJournalLine.new
              gl_journal_line.line_no=journal_header.gl_journal_lines.size+1
              gl_journal_line.gl_header_id=journal_header.id
              gl_journal_line["description"]=row[title_seq["description"]]
              gl_journal_line["department"]=row[title_seq["department"]]
              gl_journal_line["amount_cr"]=row[title_seq["amount_cr"]].to_f.round(2) unless row[title_seq["amount_cr"]].nil?
              gl_journal_line["amount_dr"]=row[title_seq["amount_dr"]].to_f.round(2) unless row[title_seq["amount_dr"]].nil?
              unless gl_journal_line.save
                error_journal_number=journal_header.journal_number
                journal_header.destroy
                Yin::GlJournalLine.where("gl_header_id" => journal_header.id).destroy_all
                error_log[error_journal_number]=gl_journal_line.errors.messages
              end
            end
          else
            gl_journal_header=Yin::GlJournalHeader.new
            if Irm::LookupValue.get_lookup_value("GL_SET_OF_BOOKS").query_by_lookup_meaning(row[title_seq["set_of_book"]]).blank?
              gl_journal_header["set_of_book"]= row[title_seq["set_of_book"]]
            else
              gl_journal_header["set_of_book"]= Irm::LookupValue.get_lookup_value("GL_SET_OF_BOOKS").query_by_lookup_meaning(row[title_seq["set_of_book"]]).first.lookup_code
            end

            gl_journal_header["journal_number"]=row[title_seq["journal_number"]]

            if Irm::LookupValue.get_lookup_value("BALANCE_METHOD").query_by_lookup_meaning(row[title_seq["balance_method"]]).blank?
              gl_journal_header["balance_method"]=row[title_seq["balance_method"]]
            else
              gl_journal_header["balance_method"]= Irm::LookupValue.get_lookup_value("BALANCE_METHOD").query_by_lookup_meaning(row[title_seq["balance_method"]]).first.lookup_code
            end
            gl_journal_header["project"]=row[title_seq["project"]]
            gl_journal_header["who_made"]=row[title_seq["who_made"]]
            gl_journal_header["accountant"]=row[title_seq["accountant"]]
            gl_journal_header["business_date"]=row[title_seq["business_date"]]
            gl_journal_header["made_date"]=row[title_seq["made_date"]]
            gl_journal_header["employee"]=row[title_seq["employee"]]
            #转为合作社id
            gl_journal_header["coop_id"]=
                Irm::Group.multilingual.query_by_name(row[title_seq["coop_id"]]).enabled.first.id unless row[title_seq["coop_id"]].nil?
            gl_journal_header["company"]=row[title_seq["company"]]
            gl_journal_header["who_approval"]=row[title_seq["who_approval"]]
            #凭证头保存成功,添加凭证行
            if gl_journal_header.save
              if row[title_seq["amount_cr"]] || row[title_seq["amount_dr"]]
                gl_journal_line = Yin::GlJournalLine.new
                gl_journal_line.line_no=gl_journal_header.gl_journal_lines.size+1
                gl_journal_line.gl_header_id=gl_journal_header.id
                gl_journal_line["description"]=row[title_seq["description"]]
                gl_journal_line["department"]=row[title_seq["department"]]
                gl_journal_line["amount_cr"]=row[title_seq["amount_cr"]].to_f.round(2) unless row[title_seq["amount_cr"]].nil?
                gl_journal_line["amount_dr"]=row[title_seq["amount_dr"]].to_f.round(2) unless row[title_seq["amount_dr"]].nil?
                #行保存失败,删除该凭证头和其他行
                unless gl_journal_line.save
                  error_journal_number=gl_journal_header.journal_number
                  gl_journal_header.destroy
                  Yin::GlJournalLine.where("gl_header_id" => gl_journal_header.id).destroy_all
                  error_log[error_journal_number]=gl_journal_line.errors.messages
                end
              else
                error_log[error_journal_number]=gl_journal_line.errors.messages
              end
            end
          end
        end
      end
    end
    error_log
  end
end
