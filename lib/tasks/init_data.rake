namespace :irm do
  desc "(For Ironmine)Menu init config."

  def merge_languages(tls, languages_hash)
    if tls and tls.any?
      tls.each do |tl|
        tl.name = languages_hash[tl.language.to_sym][:name] if languages_hash[tl.language.to_sym][:name]
        tl.description = languages_hash[tl.language.to_sym][:description]  if languages_hash[tl.language.to_sym][:description]
      end
    end
    tls
  end

  task :initdata => :environment do
    CLEAR   = "\e[0m"
    BOLD    = "\e[1m"
    RED     = "\e[31m"
    GREEN   = "\e[32m"
    YELLOW  = "\e[33m"
    BLUE    = "\e[34m"
    puts "Init data,it will takes a few seconds......"
    #根据启用的模块初始化功能组、菜单和权限数据
    begin
      rails_config = Rails.application.config
      rails_config.fwk.modules.each do |module_name|
        data_file_path = File.join(Rails.root,rails_config.fwk.module_folder,rails_config.fwk.module_mapping[module_name],'lib','init_data.rb')
        if File::exists?(data_file_path)
         require data_file_path
        end
      end
    end

    #初始化function groups
    puts "Starting init function groups......"
    function_groups = Fwk::MenuAndFunctionManager.function_groups
    function_groups ||= {}

    missing_languages_group = []
    missing_languages_function = []

    success_update_groups = []
    success_create_groups = []
    success_create_functions = []
    success_update_functions = []
    need_delete_groups = Irm::FunctionGroup.all
    #将id和code组合hash
    function_group_id_to_code = {}
    need_delete_groups.each do |m|
      function_group_id_to_code[m.id.to_sym] = m[:code]
    end
    #保存或者更新function信息
    function_groups.each do |group_code, group|
      group[:languages] ||= {}
      group[:languages][:zh] = group[:zh] if group[:zh]
      group[:languages][:en] = group[:en] if group[:en]
      group[:code] = group_code if group_code
      if group and group[:zone_code].present? and group[:code].present? and group[:controller].present? and group[:action].present?
        need_delete_groups.delete_if{|i| i[:code].to_s.eql?(group[:code].to_s)} if group.present?
        function_group = Irm::FunctionGroup.where(:code => group[:code]).first

        if function_group.present?
          function_group.not_auto_mult = true
          #更新function_group的属性
          function_group.zone_code = group[:zone_code]
          function_group.controller = group[:controller]
          function_group.action = group[:action]
          #更新function_group的多语言
          if function_group.function_groups_tls.any?
            function_group.function_groups_tls = merge_languages(function_group.function_groups_tls, group[:languages]) if group[:languages]
          elsif group[:languages]
            group[:languages].each do |key, value|
              function_group.function_groups_tls.build(:language=> key.to_s,:source_lang=>'en',:name=> value[:name],:description=>value[:description])
            end
          else
            missing_languages_group << group[:code] unless missing_languages_group.include?(group[:code])
          end
          success_update_groups << group[:code] unless success_update_groups.include?(group[:code])
        else
          function_group = Irm::FunctionGroup.new(:zone_code=>group[:zone_code],:code=>group[:code],:controller=>group[:controller],:action=>group[:action],:not_auto_mult=>true)
          # 构建对应的多语言
          if group[:languages]
            group[:languages].each do |key, value|
              function_group.function_groups_tls.build(:language=> key.to_s,:source_lang=>'en',:name=> value[:name],:description=>value[:description])
            end
          else
            missing_languages_group << group[:code] unless missing_languages_group.include?(group[:code])
          end
          success_create_groups << group[:code] unless success_create_groups.include?(group[:code])
        end
        #########################################################################################
        #保存function_group中的function
        #########################################################################################
        if function_group.save and group[:functions] and group[:functions].any?
          need_delete_functions = function_group.functions
          group[:functions].each do |function|
            if function[:code]
              need_delete_functions.delete_if{|f|f[:code].to_s.eql?(function[:code].to_s)}
              function[:languages] ||= {}
              function[:languages][:zh] = function[:zh] if function[:zh]
              function[:languages][:en] = function[:en] if function[:en]
              #查找该function是否存在
              tmp_function = Irm::Function.where(:code => function[:code]).first
              if tmp_function.present?
                #设置其group_id 为当前的group
                tmp_function.function_group_id = function_group.id
                tmp_function.not_auto_mult = true
                #更新function的属性
                tmp_function.function_group_id = function_group.id
                tmp_function.login_flag = function[:login_flag] if function[:login_flag]
                tmp_function.default_flag = function[:default_flag] if function[:default_flag]
                tmp_function.public_flag = function[:public_flag] if function[:public_flag]
                #更新function对应的多语言
                if tmp_function.functions_tls.any?
                  tmp_function.functions_tls = merge_languages(tmp_function.functions_tls, function[:languages])
                else
                  function[:languages].each do |key, value|
                    tmp_function.functions_tls.build(:language=> key.to_s,:source_lang=>'en',:name=> value[:name],:description=>value[:description])
                  end
                end
                if !function[:languages].any? and !tmp_function.functions_tls.any?
                  missing_languages_function << function[:code] unless missing_languages_function.include?(function[:code])
                end
                success_update_functions << function[:code] unless success_update_functions.include?(function[:code])
              else
                tmp_function = Irm::Function.new(:function_group_code=>group[:code],:code=>function[:code],:default_flag=>function[:default_flag],:login_flag => function[:login_flag], :public_flag=>function[:public_flag],:not_auto_mult=>true)
                # 构建对应的多语言
                if function[:languages]
                  function[:languages].each do |key, value|
                    tmp_function.functions_tls.build(:language=> key.to_s,:source_lang=>'en',:name=> value[:name],:description=>value[:description])
                  end
                else
                  missing_languages_function << function[:code] unless missing_languages_function.include?(function[:code])
                end
                success_create_functions << function[:code] unless success_create_functions.include?(function[:code])
              end
              ###################################################################################################
              tmp_function.save
              ###################################################################################################
            end
          end
          if need_delete_functions.any?
            need_delete_functions.each do |f|
              puts "#{RED} Delete function group #{group[:code]}'s child:#{f[:code].downcase}#{CLEAR}"
              f.destroy
            end
          end
        end
      end
    end
    #提示缺少多语言的groups
    if missing_languages_group.any?
      missing_languages_group.each do |g|
        puts "#{YELLOW}#{BOLD}[WARN INFO] function group #{g.downcase} missing languages#{CLEAR}"
      end
    end
    #提示缺少多语言的functions
    if missing_languages_function.any?
      missing_languages_function.each do |f|
        puts "#{YELLOW}#{BOLD}[WARN INFO] function #{f} missing languages#{CLEAR}"
      end
    end
    #记录删除的group
    if need_delete_groups.any?
      need_delete_groups.each do |g|
        puts "#{RED} Success delete function group: #{g[:code]}#{CLEAR}"
        g.destroy
      end
    end
    #提示成功更新和成功添加的
    if success_create_groups.any?
      success_create_groups.each do |g|
        puts "#{GREEN} Success Create function group:#{g.downcase}#{CLEAR}"
      end
    end
    if success_update_groups.any?
      success_update_groups.each do |g|
        puts "#{GREEN} Success Update function group:#{g.downcase}#{CLEAR}"
      end
    end
    if success_create_functions.any?
      success_create_functions.each do |f|
        puts "#{GREEN} Success Create function:#{f.downcase}#{CLEAR}"
      end
    end

    #初始化菜单
    puts "Init function groups done and now starting init menus......"
    menus = Fwk::MenuAndFunctionManager.menus
    menus ||= {}
    missing_language_menus = []
    success_create_menus = []
    success_update_menus = []
    #查找出系统中所有菜单的menu_code
    need_delete_menus = Irm::Menu.all
    #将id和code组合hash
    menu_id_to_code = {}
    need_delete_menus.each do |m|
      menu_id_to_code[m.id.to_sym] = m[:code]
    end
    has_not_saved_entries = {}
    menus.each do |code, menu|
      need_delete_menus.delete_if {|m| m[:code].to_s.include?(code.to_s)} if menu.present?
      menu[:languages] = {}
      menu[:code] = code if code.present?
      menu[:languages][:zh] = menu[:zh]? menu[:zh] : {}
      menu[:languages][:en] = menu[:en]? menu[:en] : {}
      tmp_menu = Irm::Menu.where(:code => code).first
      if tmp_menu.present?
        success_update_menus << code unless success_update_menus.include?(code)
        tmp_menu.not_auto_mult = true
        if tmp_menu.menus_tls.any? and menu[:languages].any?
          tmp_menu.menus_tls = merge_languages(tmp_menu.menus_tls, menu[:languages])
        elsif menu[:languages].any?
          menu[:languages].each do |key, value|
            tmp_menu.menus_tls.build(:language=> key.to_s,:source_lang=>'en',:name=> value[:name],:description=>value[:description])
          end
        else
          missing_language_menus << code unless missing_language_menus.include?(code)
        end
      else
        # 构建菜单
        success_create_menus << code unless success_create_menus.include?(code)
        tmp_menu = Irm::Menu.new(:code=> code,:not_auto_mult=>true)
        # 构建菜单对应的多语言
        if menu[:languages]
          menu[:languages].each do |key, value|
            tmp_menu.menus_tls.build(:language=> key.to_s,:source_lang=>'en',:name=> value[:name],:description=>value[:description])
          end
        else
          missing_language_menus << code unless missing_language_menus.include?(code)
        end
        success_create_menus << code unless success_create_menus.include?(code)
      end
      #构建菜单对应的子菜单
      #####################################################################################
      menu_save_flag = tmp_menu.save
      #####################################################################################
      if menu_save_flag and has_not_saved_entries[tmp_menu[:code].to_sym] && has_not_saved_entries[tmp_menu[:code].to_sym].any?
        has_not_saved_entries[tmp_menu[:code].to_sym].each do |entry|
          #保存该entry
          entry.not_auto_mult = true
          #############################################################################################
          entry.save
          #############################################################################################
        end
        #从该Hash中移除
        has_not_saved_entries.delete(tmp_menu[:code].to_sym)
      end
      ####################################################################################
      need_delete_entries = tmp_menu.menu_entries
      if menu_save_flag and menu[:entries] and menu[:entries].any?
        menu[:entries].each do |entry|
          need_delete_entries.delete_if{|e| e[:sub_menu_id].present? && menu_id_to_code[e[:sub_menu_id].to_sym].to_s.eql?(entry[:sub_menu_code].to_s)} if entry[:sub_menu_code].present?
          need_delete_entries.delete_if{|e|e[:sub_function_group_id].present? && function_group_id_to_code[e[:sub_function_group_id].to_sym].to_s.eql?(entry[:sub_function_group_code].to_s)} if entry[:sub_function_group_code].present?
          entry[:languages] ||= {}
          entry[:languages][:zh] = entry[:zh]? entry[:zh] : {}
          entry[:languages][:en] = entry[:en]? entry[:en] : {}
          if entry[:sub_menu_code] and entry[:sub_menu_code].present?
            menu_entry = Irm::MenuEntry.new(:menu_code=> menu[:code],:sub_menu_code=>entry[:sub_menu_code],:display_sequence=>entry[:display_sequence])
          elsif entry[:sub_function_group_code] and entry[:sub_function_group_code].present?
            menu_entry = Irm::MenuEntry.new(:menu_code=> menu[:code],:sub_function_group_code => entry[:sub_function_group_code],:display_sequence=>entry[:display_sequence])
          else
            menu_entry = nil
            puts "#{BOLD}#{YELLOW} build #{code}'s child error#{CLEAR}"
          end
          #子菜单对应的多语言
          if menu_entry.present? and entry[:languages].any?
            entry[:languages].each do |key, value|
              menu_entry.menu_entries_tls.build(:language=> key.to_s,:source_lang=>'en',:name=> value[:name],:description=>value[:description])
            end
          end
          #在保存menu_entry之前需要检查对应的sub_menu 和 sub_function_group对应的code的menu和function_group 是否存在
          delayed_save_flag = false
          sub_menu_id = nil
          if entry[:sub_menu_code] and entry[:sub_menu_code].present?
            sub_menu = Irm::Menu.where(:code => entry[:sub_menu_code]).first
            if sub_menu.present?
              delayed_save_flag = false
              sub_menu_id = sub_menu[:id]
            else
              delayed_save_flag = true
              has_not_saved_entries[entry[:sub_menu_code].to_sym] ||= []
              has_not_saved_entries[entry[:sub_menu_code].to_sym] << menu_entry
            end
          end
          sub_function_group_id = nil
          if entry[:sub_function_group_code] and entry[:sub_function_group_code].present?
            sub_function_group = Irm::FunctionGroup.where(:code => entry[:sub_function_group_code]).first
            if sub_function_group.present?
              delayed_save_flag = false
              sub_function_group_id = sub_function_group[:id]
            else
              delayed_save_flag = true
              has_not_saved_entries[entry[:sub_function_group_code].to_sym] ||= []
              has_not_saved_entries[entry[:sub_function_group_code].to_sym] << sub_function_group
            end
          end
          #保存之前判断是更新还是插入
          unless delayed_save_flag
            if sub_menu_id
              tmp_entry = Irm::MenuEntry.where(:menu_id=> tmp_menu[:id],:sub_menu_id=>sub_menu_id).first
            else
              tmp_entry = Irm::MenuEntry.where(:menu_id=> tmp_menu[:id],:sub_function_group_id => sub_function_group_id).first
            end
            if tmp_entry.present?
              if tmp_entry.menu_entries_tls.any?
                tmp_entry.menu_entries_tls = merge_languages(tmp_entry.menu_entries_tls, entry[:languages])
              end
              ###########################################################################
              tmp_entry.not_auto_mult = true
              tmp_entry.save
              #############################################################################
            else
              #######################################################################
              menu_entry.not_auto_mult = true
              menu_entry.save
              #########################################################################
            end
          end
        end

      end
      if need_delete_entries.any?
        need_delete_entries.each do |e|
          puts "#{RED}Success delete menu entry:#{e.id}"
          e.destroy
        end
      end
    end
    #需要删除的菜单
    if need_delete_menus.any?
      need_delete_menus.each do |m|
        puts "#{RED}Success delete menu:#{m[:code].downcase}#{CLEAR}"
        m.destroy
      end
    end
    #缺少语言的菜单
    if missing_language_menus.any?
      missing_language_menus.each do |m|
        puts "#{YELLOW}[WARN INFO] menu missing languages: #{m[:code]}"
      end
    end
    if success_create_menus.any?
      success_create_menus.each do |m|
        puts "#{GREEN}Success Create menu:#{m.downcase}#{CLEAR}"
      end
    end
    if success_update_menus.any?
      success_update_menus.each do |m|
        puts "#{GREEN}Success update menu:#{m.downcase}#{CLEAR}"
      end
    end

    puts "Init menus done and now starting init permissions......"
    #初始化权限
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
    functions = Fwk::MenuAndFunctionManager.functions
    functions ||={}
    function_codes = Irm::Function.all.collect{|f| f.code.upcase.to_sym}
    missing_function_codes = functions.keys.collect{|fc| fc if !function_codes.include?(fc)}.compact
    if missing_function_codes.any?
      puts "#{BOLD}#{RED}Missing function codes:#{missing_function_codes.to_json}#{CLEAR}"
    end
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
    puts "Init done! Maybe you need to restart your server."
  end
end