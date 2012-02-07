module Irm::SystemParametersManager
  class << self
    def app_top_logo
      system_params[:app_top_logo] || "/images/logos/logo.png"
    end

    def login_page_logo
      system_params[:login_page_logo]|| "/images/logos/main-logo.png"
    end

    def address_bar_logo
      system_params[:address_bar_logo] || "/favicon.ico"
    end

    def application_title
      system_params[:application_title] ||""
    end

    def host_name
      system_params[:host_name]||""
    end

    def host_path
      system_params[:host_path]||""
    end

    def host_port
      system_params[:host_port]||""
    end

    def emission_email_address
      system_params[:emission_email_address]||""
    end

    def upload_file_limit
      system_params[:upload_file_limit].to_f
    end

    def timezone
      system_params[:timezone]||""
    end

    def error_404_text
      system_params[:error_404_text]||""
    end

    def error_500_text
      system_params[:error_500_text]||""
    end

    def error_422_text
      system_params[:error_422_text]||""
    end

    def error_access_deny_text
      system_params[:error_access_deny_text]||""
    end

    def reset_system_parameters
      prepare_system_parameters_cache
    end

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
  end
end