module Ndm
  module Jobs
    class ImportExcelJob<Struct.new(:att_id)
      def perform
        # 查找需要处理的事件
        import_list = Ndm::TmpDevManagement.where("import_status = ?", 'N').where("source_id = ?", att_id)
        return nil unless import_list.any?
        import_list.each do |i|
          module_lookup = Irm::LookupValue.select_all.
              joins(",#{Irm::LookupValuesTl.table_name} lt").
              where("lt.lookup_value_id = #{Irm::LookupValue.table_name}.id").
              where("lt.language = ?", "zh").
              query_by_lookup_type("DEM_MODULE").
              where("lt.meaning = ?", i.module).
              select("lt.meaning")
          branch_lookup = Irm::LookupValue.select_all.
              joins(",#{Irm::LookupValuesTl.table_name} lt").
              where("lt.lookup_value_id = #{Irm::LookupValue.table_name}.id").
              where("lt.language = ?", "zh").
              query_by_lookup_type("NDM_BRANCH").
              where("lt.meaning = ?", i.branch).
              select("lt.meaning")
          priority_lookup = Irm::LookupValue.select_all.
              joins(",#{Irm::LookupValuesTl.table_name} lt").
              where("lt.lookup_value_id = #{Irm::LookupValue.table_name}.id").
              where("lt.language = ?", "zh").
              query_by_lookup_type("NDM_PRIORITY").
              where("lt.meaning = ?", i.priority).
              select("lt.meaning")
          method_lookup = Irm::LookupValue.select_all.
              joins(",#{Irm::LookupValuesTl.table_name} lt").
              where("lt.lookup_value_id = #{Irm::LookupValue.table_name}.id").
              where("lt.language = ?", "zh").
              query_by_lookup_type("NDM_METHOD").
              where("lt.meaning = ?", i.method).
              select("lt.meaning")
          dev_type_lookup = Irm::LookupValue.select_all.
              joins(",#{Irm::LookupValuesTl.table_name} lt").
              where("lt.lookup_value_id = #{Irm::LookupValue.table_name}.id").
              where("lt.language = ?", "zh").
              query_by_lookup_type("NDM_TYPE").
              where("lt.meaning = ?", i.dev_type).
              select("lt.meaning")
          dev_difficulty_lookup = Irm::LookupValue.select_all.
              joins(",#{Irm::LookupValuesTl.table_name} lt").
              where("lt.lookup_value_id = #{Irm::LookupValue.table_name}.id").
              where("lt.language = ?", "zh").
              query_by_lookup_type("NDM_DIFFICULTY").
              where("lt.meaning = ?", i.dev_difficulty).
              select("lt.meaning")
          #See if management exists
          ex_list = Ndm::DevManagement.where("branch = ?", branch_lookup.first.lookup_code).where("no = ?", i.no)
          if ex_list.any?
            n = ex_list.first
          else
            n = Ndm::DevManagement.new()
          end

          if module_lookup.any?
            n.module = module_lookup.first.lookup_code
          else
            nil
          end

          if branch_lookup.any?
            n.branch = branch_lookup.first.lookup_code
          else
            i.import_status = 'E'
            i.message = "Miss Branch"
            i.save
            next
          end

          if priority_lookup.any?
            n.priority = priority_lookup.first.lookup_code
          else
            nil
          end

          if method_lookup.any?
            n.method = method_lookup.first.lookup_code
          else
            nil
          end

          if dev_type_lookup.any?
            n.dev_type = dev_type_lookup.first.lookup_code
          else
            nil
          end

          if dev_difficulty_lookup.any?
            n.dev_difficulty = dev_difficulty_lookup.first.lookup_code
          else
            nil
          end

          p_status_lookup = Irm::LookupValue.select_all.
              joins(",#{Irm::LookupValuesTl.table_name} lt").
              where("lt.lookup_value_id = #{Irm::LookupValue.table_name}.id").
              where("lt.language = ?", "zh").
              query_by_lookup_type("NDM_PHASE_STATUS").
              select("lt.meaning")

          n.project = i.project
          #gen no.
          n.no = i.no
          n.name = i.name
          n.description = i.description

          n.gd_owner = i.gd_owner
          begin
            n.gd_status = p_status_lookup.where("lt.meaning = ?", i.gd_status).first.lookup_code
          rescue
            nil
          end
          n.gd_plan_start = i.gd_plan_start
          n.gd_plan_end = i.gd_plan_end

          n.fd_owner = i.fd_owner
          begin
            n.fd_status = p_status_lookup.where("lt.meaning = ?", i.fd_status).first.lookup_code
          rescue
            nil
          end
          n.fd_plan_start = i.fd_plan_start
          n.fd_plan_end = i.fd_plan_end

          n.fdr_owner = i.fdr_owner
          begin
            n.fdr_status = p_status_lookup.where("lt.meaning = ?", i.fdr_status).first.lookup_code
          rescue
            nil
          end
          n.fdr_plan_end = i.fdr_plan_end

          n.td_owner = i.td_owner
          begin
            n.td_status = p_status_lookup.where("lt.meaning = ?", i.td_status).first.lookup_code
          rescue
            nil
          end
          n.td_plan_end = i.td_plan_end

          n.co_owner = i.co_owner
          n.co_status = i.co_status
          begin
            n.co_status = p_status_lookup.where("lt.meaning = ?", i.co_status).first.lookup_code
          rescue
            nil
          end
          n.co_plan_end = i.co_plan_end

          n.te_owner = i.te_owner
          begin
            n.te_status = p_status_lookup.where("lt.meaning = ?", i.te_status).first.lookup_code
          rescue
            nil
          end
          n.te_plan_end = i.te_plan_end

          n.si_owner = i.si_owner
          begin
            n.si_status = p_status_lookup.where("lt.meaning = ?", i.si_status).first.lookup_code
          rescue
            nil
          end
          n.si_plan_end = i.si_plan_end

          n.at_owner = i.at_owner
          begin
            n.at_status = p_status_lookup.where("lt.meaning = ?", i.at_status).first.lookup_code
          rescue
            nil
          end
          n.at_plan_end = i.at_plan_end

          n.go_owner = i.go_owner
          begin
            n.go_status = p_status_lookup.where("lt.meaning = ?", i.go_status).first.lookup_code
          rescue
            nil
          end
          n.go_plan_end = i.go_plan_end

          n.opu_id = "001n00012i8IyyjJakd6Om"

          if n.save
            n.update_dev_status
            i.import_status = 'C'
            i.save
            next
          else
            i.import_status = 'E'
            i.message = n.errors.to_json
            i.save
            next
          end
        end

        #update sequence
        branch_list = Irm::LookupValue.select_all.query_by_lookup_type("NDM_BRANCH")
        branch_list.each do |bl|
          ses = Ndm::DevManagement.wherle("#{Ndm::DevManagement.table_name}.id = (SELECT t.id FROM ndm_dev_managements t WHERE t.branch = ? ORDER BY t.no + 0 DESC LIMIT 1)", bl.lookup_code).select("#{Ndm::DevManagement.table_name}.no")
          next unless ses.any?
          se = ses.first
          s = Irm::Sequence.where("object_name = ?", bl.lookup_code).first
          s.update_attribute(:seq_next, se.no)
        end
      end
    end
  end
end