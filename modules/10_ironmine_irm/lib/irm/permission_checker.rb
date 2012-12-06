class Irm::PermissionChecker
  # 确认当前用户是否有权限访问链接
  # 页面上的链接数量太多，采用缓存将页面permission信息存储
  def self.allow_to_url?(url_options={})
    return false unless (url_options[:page_controller]||url_options[:controller]).present?&&(url_options[:page_action]||url_options[:action]).present?
    url_options.symbolize_keys!
    permission_key =  Irm::Permission.url_key(url_options[:page_controller]||url_options[:controller],url_options[:page_action]||url_options[:action])
    assigned_to_functions = Irm::MenuManager.permissions[permission_key]
    assigned_to_functions||=[]
    if url_options[:sid].present?&&Irm::MenuManager.system_permissions.include?(permission_key)
      assigned_to_functions = assigned_to_functions.collect{|i| i.gsub("{sid}","#{url_options[:sid]}")}
    end

    if assigned_to_functions
      public_functions = Irm::MenuManager.public_functions
      return true if assigned_to_functions.detect{|f| public_functions.include?(f)}
      return false unless Irm::Person.current.logged?
      login_functions = Irm::MenuManager.login_functions
      return true if assigned_to_functions.detect{|f| login_functions.include?(f)}
      return Irm::Person.current.allowed_to?(assigned_to_functions)
    end
  end

  def self.public?(url_options={})
    url_options.symbolize_keys!
    assigned_to_functions = Irm::MenuManager.permissions[Irm::Permission.url_key(url_options[:page_controller]||url_options[:controller],url_options[:page_action]||url_options[:action])]
    public_functions = Irm::MenuManager.public_functions
    return true if assigned_to_functions&&assigned_to_functions.detect{|f| public_functions.include?(f)}
    false
  end


  def self.allow_to_function?(function_code,sid=nil)
    function = Irm::MenuManager.functions[function_code.to_s.upcase]
    return false unless function
    return true if Irm::MenuManager.public_functions.include?(function[:id])
    return false unless Irm::Person.current.logged?
    return true if Irm::MenuManager.login_functions.include?(function[:id])
    function_ids =  [function[:id]]
    function_ids = ["#{sid}_#{function[:id]}"] if sid.present?&&Irm::Constant::SYS_YES.eql?(function[:system_flag])
    Irm::Person.current.allowed_to?(function_ids)
  end

end