class AddRDateToNdm < ActiveRecord::Migration
  def change
    add_column :ndm_dev_managements, :gd_real_start, :date, :after => :gd_plan_start
    add_column :ndm_dev_managements, :gd_real_end, :date, :after => :gd_plan_end

    add_column :ndm_dev_managements, :fd_real_start, :date, :after => :fd_plan_start
    add_column :ndm_dev_managements, :fd_real_end, :date, :after => :fd_plan_end

    add_column :ndm_dev_managements, :fdr_real_end, :date, :after => :fdr_plan_end

    add_column :ndm_dev_managements, :td_real_end, :date, :after => :td_plan_end

    add_column :ndm_dev_managements, :co_real_end, :date, :after => :co_plan_end

    add_column :ndm_dev_managements, :te_real_end, :date, :after => :te_plan_end

    add_column :ndm_dev_managements, :si_real_end, :date, :after => :si_plan_end

    add_column :ndm_dev_managements, :at_real_end, :date, :after => :at_plan_end

    add_column :ndm_dev_managements, :si_real_end, :date, :after => :go_plan_end
  end
end
