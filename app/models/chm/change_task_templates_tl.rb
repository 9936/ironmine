class Chm::ChangeTaskTemplatesTl < ActiveRecord::Base
  set_table_name :chm_change_task_templates_tl

  belongs_to :change_task_template

  validates_presence_of :name
end
