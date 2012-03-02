class Irm::SystemParameterValue < ActiveRecord::Base
  set_table_name :irm_system_parameter_values
  has_attached_file :img
  validates_attachment_size :img #, :less_than => Irm::SystemParametersManager.upload_file_limit.kilobytes

   #加入activerecord的通用方法和scope
   query_extend
   # 对运维中心数据进行隔离
   default_scope {default_filter}
   belongs_to :system_parameter #设置主从关系

  def self.global_setting
    if @global_setting&&Irm::OperationUnit.current
      return @global_setting
    else
      return  @global_setting=query_by_type("GLOBAL_SETTING")
    end

  end

  def self.skm_setting
    if @skm_setting&&Irm::OperationUnit.current
      @skm_setting
    else
      @skm_setting=query_by_type("SKM_SETTING")
    end
  end

  scope :with_parameter,lambda{
    joins(",irm_system_parameters_vl").
            where("irm_system_parameters_vl.id=#{table_name}.system_parameter_id and irm_system_parameters_vl.language=?",I18n.locale).
            select("#{table_name}.*,irm_system_parameters_vl.name name,irm_system_parameters_vl.parameter_code,"+
                       "irm_system_parameters_vl.content_type,irm_system_parameters_vl.data_type,irm_system_parameters_vl.validation_format,"+
                       "irm_system_parameters_vl.validation_content,irm_system_parameters_vl.validation_type,irm_system_parameters_vl.position")
  }
  scope :query_by_code,lambda{|param_code|
    with_parameter.
        where("irm_system_parameters_vl.parameter_code=?",param_code)
  }
  scope :query_by_type,lambda{|type_code|
    with_parameter.
        where("irm_system_parameters_vl.content_type=?",type_code)
  }

end
