module Irm::SystemParametersManager
  class << self
    def app_top_logo
      if !Irm::OperationUnit.current
        value=Irm::SystemParameterValue.global_setting.detect{|i| i[:parameter_code].downcase.eql?("app_top_logo")}
        if value.present?
          return value.img|| "/images/logos/logo.png"
        end

      else
        "/images/logos/logo.png"
      end
    end

    def login_page_logo
      if Irm::OperationUnit.current
        value=Irm::SystemParameterValue.global_setting.detect{|i| i[:parameter_code].downcase.eql?("login_page_logo")}
        if value.present?
          return value.img|| "/images/logos/main-logo.png"
        end

      else
        "/images/logos/main-logo.png"
      end
    end

    def address_bar_logo
      if Irm::OperationUnit.current
        paramvalue=Irm::SystemParameterValue.global_setting.detect{|i| i[:parameter_code].downcase.eql?("address_bar_logo")}
        if paramvalue.present?
          return paramvalue.img
        else
          return "/favicon.ico"
        end

      else
        ""
      end
    end

    def application_title
      if Irm::OperationUnit.current
        paramvalue= Irm::SystemParameterValue.global_setting.detect{|i| i[:parameter_code].downcase.eql?("application_title")}
        if paramvalue.present?
          return paramvalue.value ||""
        end
      else
        ""
      end
    end

    def host_name
      paramvalue= Irm::SystemParameterValue.global_setting.detect{|i| i[:parameter_code].downcase.eql?("host_name")}
      if paramvalue.present?
        return paramvalue.value ||""
      end
    end

    def host_path
      paramvalue= Irm::SystemParameterValue.global_setting.detect{|i| i[:parameter_code].downcase.eql?("host_path")}
      if paramvalue.present?
        return paramvalue.value ||""
      end
    end

    def host_port
      paramvalue= Irm::SystemParameterValue.global_setting.detect{|i| i[:parameter_code].downcase.eql?("host_port")}
      if paramvalue.present?
        return paramvalue.value ||""
      end
    end

    def emission_email_address
      paramvalue= Irm::SystemParameterValue.global_setting.detect{|i| i[:parameter_code].downcase.eql?("emission_email_address")}
      if paramvalue.present?
        return paramvalue.value ||""
      end
    end

    def upload_file_limit
      paramvalue= Irm::SystemParameterValue.global_setting.detect{|i| i[:parameter_code].downcase.eql?("upload_file_limit")}
      if paramvalue.present?
        return paramvalue.value.to_f||100000.0
      end
    end

    def timezone
      paramvalue= Irm::SystemParameterValue.global_setting.detect{|i| i[:parameter_code].downcase.eql?("timezone")}
      if paramvalue.present?
        return paramvalue.value ||""
      end
    end

    def error_404_text
      paramvalue= Irm::SystemParameterValue.global_setting.detect{|i| i[:parameter_code].downcase.eql?("error_404")}
      if paramvalue.present?
        return paramvalue.value ||""
      end
    end

    def error_500_text
      paramvalue= Irm::SystemParameterValue.global_setting.detect{|i| i[:parameter_code].downcase.eql?("error_500")}
      if paramvalue.present?
        return paramvalue.value ||""
      end
    end

    def error_422_text
      paramvalue= Irm::SystemParameterValue.global_setting.detect{|i| i[:parameter_code].downcase.eql?("error_422")}
      if paramvalue.present?
        return paramvalue.value ||""
      end
    end

    def error_access_deny_text
      paramvalue= Irm::SystemParameterValue.global_setting.detect{|i| i[:parameter_code].downcase.eql?("error_access_deny")}
      if paramvalue.present?
        return paramvalue.value ||""
      end
    end

    def enable_skm_header_audit
      paramvalue= Irm::SystemParameterValue.skm_setting.detect{|i| i[:parameter_code].eql?("SKM_HEADER_AUDIT")}
      if paramvalue.present?
        return paramvalue.value ||""
      end
    end
=begin

    def reset_system_parameters
      prepare_system_parameters_cache
    end

   #依据Feature #1176对系统参数功能添加多云运维中心支持   取消系统参数缓存功能
 def prepare_system_parameters_cache

      login_page_logo = Irm::SystemParameter.query_by_code("LOGIN_PAGE_LOGO")
      app_top_logo = Irm::SystemParameter.query_by_code("APP_TOP_LOGO")
      address_bar_logo = Irm::SystemParameter.query_by_code("ADDRESS_BAR_LOGO")

      application_title = Irm::SystemParameter.query_by_code("APPLICATION_TITLE")
      host_name = Irm::SystemParameter.query_by_code("HOST_NAME")
      host_path = Irm::SystemParameter.query_by_code("HOST_PATH")
      emission_email_address = Irm::SystemParameter.query_by_code("EMISSION_EMAIL_ADDRESS")

      upload_file_limit = Irm::SystemParameter.query_by_code("UPLOAD_FILE_LIMIT")
      timezone = Irm::SystemParameter.query_by_code("TIMEZONE")

      host_port = Irm::SystemParameter.query_by_code("HOST_PORT")

      error_404_text = Irm::SystemParameter.query_by_code("ERROR_404")
      error_500_text = Irm::SystemParameter.query_by_code("ERROR_500")
      error_422_text = Irm::SystemParameter.query_by_code("ERROR_422")
      error_access_deny_text = Irm::SystemParameter.query_by_code("ERROR_ACCESS_DENY")

      map.merge!({:app_top_logo => app_top_logo.first.img.url}) if app_top_logo.any? && app_top_logo.first.value.present?
      map.merge!({:login_page_logo => login_page_logo.first.img.url}) if login_page_logo.any? && login_page_logo.first.value.present?
      map.merge!({:address_bar_logo => address_bar_logo.first.img.url}) if address_bar_logo.any? && address_bar_logo.first.value.present?

      map.merge!({:application_title => application_title.first.value}) if application_title.any?
      map.merge!({:host_name => host_name.first.value}) if host_name.any?
      map.merge!({:host_path => host_path.first.value}) if host_path.any?
      map.merge!({:emission_email_address => emission_email_address.first.value}) if emission_email_address.any?

      map.merge!({:upload_file_limit => upload_file_limit.first.value}) if upload_file_limit.any?
      map.merge!({:timezone => timezone.first.value}) if timezone.any?

      map.merge!({:host_port => host_port.first.value}) if host_port.any?

      map.merge!({:error_404_text => error_404_text.first.value}) if error_404_text.any?
      map.merge!({:error_500_text => error_500_text.first.value}) if error_500_text.any?
      map.merge!({:error_422_text => error_422_text.first.value}) if error_422_text.any?
      map.merge!({:error_access_deny_text => error_access_deny_text.first.value}) if error_access_deny_text.any?
    end

    # =====================================生成logo缓存===============================================
    #将数据加载至内存
    def map
      @system_params =Ironmine::STORAGE.get(:system_parameter_manager_items)||{}
      if block_given?
        yield @system_params
      end
      Ironmine::STORAGE.put(:system_parameter_manager_items,@system_params)
    end

    # 从内存中读取数据
    def system_params
      Ironmine::STORAGE.get(:system_parameter_manager_items)||{}
    end

    private :map, :system_params
=end

  end
end