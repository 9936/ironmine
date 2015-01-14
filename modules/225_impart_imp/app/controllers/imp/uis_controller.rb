class Imp::UisController < ApplicationController
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
