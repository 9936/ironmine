class AddFixedDateToNdm < ActiveRecord::Migration
  def change
    add_column :ndm_dev_managements, :fdr_real_start, :date, :after => :fdr_plan_end
    add_column :ndm_dev_managements, :fdr_plan_start, :date, :after => :fdr_plan_end

    add_column :ndm_dev_managements, :td_real_start, :date, :after => :td_plan_end
    add_column :ndm_dev_managements, :td_plan_start, :date, :after => :td_plan_end

    add_column :ndm_dev_managements, :co_real_start, :date, :after => :co_plan_end
    add_column :ndm_dev_managements, :co_plan_start, :date, :after => :co_plan_end

    add_column :ndm_dev_managements, :te_real_start, :date, :after => :te_plan_end
    add_column :ndm_dev_managements, :te_plan_start, :date, :after => :te_plan_end

    add_column :ndm_dev_managements, :si_real_start, :date, :after => :si_plan_end
    add_column :ndm_dev_managements, :si_plan_start, :date, :after => :si_plan_end

    add_column :ndm_dev_managements, :at_real_start, :date, :after => :at_plan_end
    add_column :ndm_dev_managements, :at_plan_start, :date, :after => :at_plan_end

    add_column :ndm_dev_managements, :go_real_start, :date, :after => :go_plan_end
    add_column :ndm_dev_managements, :go_plan_start, :date, :after => :go_plan_end
  end
end
