class AddCategoryToRequestMail < ActiveRecord::Migration
  def up
    add_column :icm_mail_requests,:incident_sub_category_id,:string,:limit => 22, :collate=>"utf8_bin",:after=>:service_code
    add_column :icm_mail_requests,:incident_category_id,:string,:limit => 22, :collate=>"utf8_bin",:after=>:service_code
  end

  def down
    remove_column :icm_mail_requests,:incident_sub_category_id
    remove_column :icm_mail_requests,:incident_category_id
  end
end
