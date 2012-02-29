class CreateAndAdjustSystemParam < ActiveRecord::Migration
  def up
    create_table :irm_system_parameter_values do |t|
               t.string   "opu_id",        :limit => 22 , :collate=>"utf8_bin"
               t.string   "system_parameter_id", :limit => 22,                         :null => false
               t.string   "value",              :limit => 240
               t.datetime "img_updated_at"
               t.integer  "img_file_size"
               t.string   "img_content_type",   :limit => 60
               t.string   "img_file_name",      :limit => 60
               t.string   "status_code",      :limit => 30, :default => "ENABLED",:null => false
               t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
               t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
               t.datetime "created_at"
               t.datetime "updated_at"
             end
             change_column :irm_system_parameter_values, "id", :string,:limit=>22, :collate=>"utf8_bin"

        Irm::SystemParameter.all.each do |param|
          system_parameter_id=Irm::SystemParameter.where(:parameter_code=>param[:parameter_code],:opu_id=>"001n00012i8IyyjJakd6Om").first.id

          paramvalue=Irm::SystemParameterValue.new(:opu_id=>param[:opu_id],:system_parameter_id=>system_parameter_id,
              :value=>param[:value],:img_updated_at=>param[:img_updated_at],
              :img_file_size=>param[:img_file_size], :img_content_type=>param[:img_content_type] ,
              :img_file_name=>param[:img_file_name]
             )
          paramvalue.save
        end
        Irm::SystemParameter.where("opu_id<>'001n00012i8IyyjJakd6Om'").delete_all
        Irm::SystemParametersTl.where("opu_id<>'001n00012i8IyyjJakd6Om'").delete_all
        remove_column :irm_system_parameters, :value,:img_updated_at ,:img_file_size,:img_content_type, :img_file_name
        execute('CREATE OR REPLACE VIEW irm_system_parameters_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                             FROM irm_system_parameters t,irm_system_parameters_tl tl
                             WHERE t.id = tl.system_parameter_id')
  end

  def down
  end
end
