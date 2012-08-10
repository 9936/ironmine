namespace :irm do
  desc "(For Ironmine)Migrate the permission config."
  task :initpermission => :environment do
    CLEAR   = "\e[0m"
    BOLD    = "\e[1m"
    RED     = "\e[31m"
    YELLOW  = "\e[33m"
    BLUE    = "\e[34m"
    begin
      # 初始化模块数据 ，初始化脚本位于lib/模块/init.rb脚本中
      Irm::ProductModule.enabled.each do |p|
        if File::exists?(File.join(Rails.root, "lib","#{p.product_short_name.downcase}","init_permission.rb"))
          require "#{p.product_short_name.downcase}/init_permission"
        end
      end

      Dir[Rails.root.join('modules','*','lib','*', 'init_permission.rb')].each do |file_path|
        require "#{file_path}"
      end
      Dir[Rails.root.join('modules','*','lib', 'init_permission.rb')].each do |file_path|
        require "#{file_path}"
      end

    end

    begin
     all_routes = Rails.application.routes.routes
     routes = all_routes.collect do |route|
       key_method = Hash.method_defined?('key') ? 'key' : 'index'
       name = Rails.application.routes.named_routes.routes.send(key_method, route).to_s
       reqs = route.requirements.empty? ? "" : route.requirements.inspect
       {:name => name, :verb => route.verb.to_s, :path => route.path, :reqs => reqs}
     end
     routes.reject!{ |r| r[:path] == "/rails/info/properties" } # skip the route if it's internal info route
     route_permissions = []
     path_regex = /:([a-z_]+)/
     except_path_regex = /\([\.\/a-z_]*:([a-z_]+)[\/a-z_]*\)/
     routes.each do |r|
       next unless r[:reqs].present?
       params_count = r[:path].scan(path_regex).delete_if{|i| !i.any?}.count
       except_params_count = r[:path].scan(except_path_regex).delete_if{|i| !i.any?}.count
       params_count = params_count - except_params_count
       permission_params = eval(r[:reqs])
       permission_params.merge!({:params_count=>params_count,:direct_get_flag=>r[:verb].include?("GET") ? Irm::Constant::SYS_YES : Irm::Constant::SYS_NO})
       route_permissions<<permission_params
     end
    end
    not_inited_route_permissions = route_permissions.dup

    #functions = Fwk::AccessControl.functions
    functions = Fwk::MenuAndFunctionManager.functions
    functions ||={}
    function_codes = Irm::Function.all.collect{|f| f.code.upcase.to_sym}
    missing_function_codes = functions.keys.collect{|fc| fc if !function_codes.include?(fc)}.compact
    puts "#{BOLD}#{RED}Missing function codes:#{missing_function_codes.to_json}#{CLEAR}"
    Irm::Permission.update_all("status_code = 'UNKNOW'")
    functions.each do |function_code,function|
      permissions =  function[:permissions]
      permissions.each do |controller,actions|
        actions.each do |action|
          route_permission = route_permissions.detect{|rp| rp[:controller].eql?(controller)&&rp[:action].eql?(action.to_s)}
          if route_permission.nil?
            puts "#{BOLD}#{RED}No route match #{controller}/#{action.to_s}#{CLEAR}"
            next
          end
          not_inited_route_permissions.delete_if{|rp| rp[:controller].eql?(controller)&&rp[:action].eql?(action.to_s)}
          permission = Irm::Permission.query_by_function_code(function_code.to_s.upcase).where(:controller=>controller,:action=>action.to_s).readonly(false).first
          if permission
            permission.update_attributes({:params_count=>route_permission[:params_count],:direct_get_flag=>route_permission[:direct_get_flag],:status_code=>"ENABLED"})
          else
            permission = Irm::Permission.new(:code=>Irm::Permission.url_key(controller,action).upcase,:function_code=>function_code.to_s.upcase,:controller=>controller,:action=>action.to_s,:params_count=>route_permission[:params_count],:direct_get_flag=>route_permission[:direct_get_flag])
            permission.save
            if permission.errors.any?
              puts "#{BOLD}#{RED}Add [#{function_code}]#{controller}/#{action} errors:#{permission.errors}#{CLEAR}"
            else
              puts "Add [#{function_code}]#{controller}/#{action} to permissions successful"
            end
          end
        end
      end

    end
    deleted_row = Irm::Permission.delete_all("status_code = 'UNKNOW'")
    puts "#{BOLD}#{RED}Delete #{deleted_row} row#{CLEAR}"

    puts "#{BOLD}#{YELLOW}Not init route permissions #{CLEAR}"
    not_inited_route_permissions.each do |rp|
      puts "#{YELLOW}#{rp[:controller]}/#{rp[:action]} #{CLEAR}"
    end

    Irm::FunctionGroup.all.each do |fg|
      permission = Irm::Permission.query_by_function_group(fg.id).where(:controller=>fg.controller,:action=>fg.action).first
      if(permission)
        if(permission.params_count>0||Irm::Constant::SYS_NO.eql?(permission.direct_get_flag))
          puts "#{BOLD}#{BLUE}FunctionGroup  [#{fg.id}:#{fg.code}] USE <#{fg.controller}/#{fg.action}> is have params OR can not direct get #{CLEAR}"
        end
      else
        puts "#{BOLD}#{BLUE}FunctionGroup  [#{fg.id}:#{fg.code}] USE <#{fg.controller}/#{fg.action}> is error #{CLEAR}"
      end
    end
  end
end