module Fwk::MenuAndFunctionManager
  class << self
    def map
      @menus ||= {}
      @function_groups ||= {}
      @functions ||= {}
      mapper = Mapper.new
      if block_given?
        yield mapper
      else
        mapper
      end
      #合并menus
      new_menus = mapper.mapped_menus
      new_menus.each do |code, menu|
        menu = menu.dup
        if @menus[code.to_sym].present?
          menu.keys.each do |i|
            if @menus[code.to_sym][i.to_sym].is_a?(Array)
              #判断是否重复添加
              menu[i.to_sym].each do |m|
                @menus[code.to_sym][i.to_sym].delete_if {|n| n[:sub_menu_code].to_s.eql?(m[:sub_menu_code].to_s)}
                @menus[code.to_sym][i.to_sym].delete_if {|n| n[:sub_function_group_code].to_s.eql?(m[:sub_function_group_code].to_s)}
                @menus[code.to_sym][i.to_sym] << m
              end
            else
              @menus[code.to_sym].merge!({i.to_sym => menu[i.to_sym] })
            end
          end
        else
          @menus.merge!({code.to_sym => menu})
        end
      end if new_menus
      #合并function_groups
      new_function_groups = mapper.mapped_function_groups
      new_function_groups.each do |code, group|
        group = group.dup
        if @function_groups[code.to_sym].present?
          group.keys.each do |i|
            if @function_groups[code.to_sym][i.to_sym].is_a?(Array)
              #判断是否重复添加
              group[i.to_sym].each do |g|
                @function_groups[code.to_sym][i.to_sym].delete_if {|n| n[:code].to_s.eql?(g[:code].to_s)}
                @function_groups[code.to_sym][i.to_sym] << g
              end
            else
              @function_groups[code.to_sym].merge!({i.to_sym => group[i.to_sym] })
            end
          end
        else
          @function_groups.merge!({code.to_sym => group})
        end
      end if new_function_groups
      #合并functions
      added_functions = mapper.mapped_functions||[]
      added_functions.each do |function_code,function|
        if @functions.keys.include?(function_code.to_sym)
          exists_permissions  = @functions[function_code.to_sym][:permissions]
          permissions = function[:permissions].dup
          exists_permissions.each do |controller,actions|
            if(function[:permissions][controller])
              exists_permissions[controller] += function[:permissions][controller]
              exists_permissions[controller].uniq!
              permissions.delete(controller)
            end
          end
          exists_permissions.merge!(permissions)
        else
          @functions.merge!({function_code.to_sym=>function})
        end
      end
    end

    def menus
      @menus
    end

    def function_groups
      @function_groups
    end

    def functions
      @functions
    end

    # Returns the permission of given name or nil if it wasn't found
    # Argument should be a symbol
    def function(name)
      functions[name.to_sym]
    end
    # Returns the actions that are allowed by the permission of given name
    def allowed_actions(permission_name)
      perm = permission(permission_name)
      perm ? perm.actions : []
    end

    def public_permissions
      @public_permissions ||= @permissions.select {|p| p.public?}
    end

    def members_only_permissions
      @members_only_permissions ||= @permissions.select {|p| p.require_member?}
    end

    def loggedin_only_permissions
      @loggedin_only_permissions ||= @permissions.select {|p| p.require_loggedin?}
    end

    def available_project_modules
      @available_project_modules ||= @permissions.collect(&:project_module).uniq.compact
    end

    def modules_permissions(modules)
      @permissions.select {|p| p.project_module.nil? || modules.include?(p.project_module.to_s)}
    end

  end

  class Mapper
    def initialize
      @menus ||= {}
      @function_groups ||= {}
      @functions ||= {}
    end

    def function_group(code, hash)
      if code.present? and hash.any?
        hash = hash.dup
        hash[:code] = code.upcase
        handle_function_group(hash)
      end
    end

    def menu(code, hash = {}, options ={})
      if code.present? and hash.any?
        hash = hash.dup
        hash[:code] = code
        handle_menu(hash)
      end
    end

    #递归处理功能组下的子功能
    def handle_function_group(hash)
      hash = hash.dup
      code = hash[:code].upcase
      @function_groups[code.to_sym] ||= {}
      tmp ||= {}
      if code.present? and hash and hash.any?
        tmp[code.to_sym] ||= {}
        tmp[code.to_sym][:zh] = hash[:zh] if hash[:zh]
        tmp[code.to_sym][:en] = hash[:en] if hash[:en]
        tmp[code.to_sym][:zone_code] = hash[:zone_code].upcase if hash[:zone_code]
        tmp[code.to_sym][:controller] = hash[:controller] if hash[:controller]
        tmp[code.to_sym][:action] = hash[:action] if hash[:action]
        if hash[:children] and hash[:children].any?
          @function_groups[code.to_sym][:functions] ||= []
          function_keys = ["code","en","zh","default_flag", "public_flag", "login_flag"]
          hash[:children].each do |key, child|
            child[:code] = key.upcase
            child = child.dup
            function ||= {}
            function[:code] = child[:code] if child[:code]
            function[:en] = child[:en] if child[:en]
            function[:zh] = child[:zh] if child[:zh]
            function[:default_flag] = child[:default_flag] || 'N'
            function[:login_flag] = child[:login_flag] || 'N'
            function[:public_flag] = child[:public_flag] || 'N'
            @function_groups[code.to_sym][:functions].delete_if {|i| i[:code].to_s.eql?(child[:code].to_s)}
            @function_groups[code.to_sym][:functions] << function

            #添加权限控制
            child.keys.each do |k|
              unless function_keys.include?(k.to_s)
                permission_hash = {k.to_s => child[k.to_s]}
                if @functions.keys.include?(child[:code].to_sym)
                  exists_permissions  = @functions[child[:code].to_sym][:permissions]
                  permissions = permission_hash.dup
                  exists_permissions.each do |controller,actions|
                    if(permission_hash[controller])
                      exists_permissions[controller] += permission_hash[controller]
                      exists_permissions[controller].uniq!
                      permissions.delete(controller)
                    end
                  end
                  exists_permissions.merge!(permissions)
                else
                  @functions.merge!({child[:code].to_sym=>{:permissions=>permission_hash}})
                end
              end
            end

            @function_groups[code.to_sym].merge!(tmp[code.to_sym])
            #handle_function_group(child)
          end
        else
          @function_groups[code.to_sym].merge!(tmp[code.to_sym])
        end
      end
    end


    #递归处理子菜单
    def handle_menu(hash)
      hash = hash.dup
      code = hash[:code].upcase
      tmp ||= {}

      if code.present? && hash && hash.any?
        tmp[code.to_sym] ||= {}
        tmp[code.to_sym][:zh] = hash[:zh] if hash[:zh]
        tmp[code.to_sym][:en] = hash[:en] if hash[:en]
        if hash[:type] and hash[:type].to_s.eql?('function')
          @function_groups[code.to_sym] ||= {}
          tmp[code.to_sym][:zone_code] = hash[:zone_code].upcase if hash[:zone_code]
          tmp[code.to_sym][:controller] = hash[:controller] if hash[:controller]
          tmp[code.to_sym][:action] = hash[:action] if hash[:action]
        else
          @menus[code.to_sym] ||= {}
        end

        if hash[:children] and hash[:children].any?
          @menus[code.to_sym][:entries] ||= []
          hash[:children].each do |key, child|
            child[:code] = key.upcase
            child = child.dup
            if child[:type] and child[:type].to_s.eql?("function")
              type_code = "sub_function_group_code"
            else
              type_code = "sub_menu_code"
            end

            entry ||= {}
            entry[type_code.to_sym] = child[:code] if child[:code]
            if child[:entry]
              entry[:display_sequence] = child[:entry][:sequence]? child[:entry][:sequence] : 10
              entry[:zh] = child[:entry][:zh] if child[:entry][:zh]
              entry[:en] = child[:entry][:en] if child[:entry][:en]
              @menus[code.to_sym][:entries].delete_if {|i| i[type_code.to_sym].to_s.eql?(child[:code].to_s)}
              @menus[code.to_sym][:entries] << entry
            else
              "==============================ERROR=========================="
            end
            @menus[code.to_sym].merge!(tmp[code.to_sym])
            handle_menu(child)
          end
        else
          if hash[:type] and hash[:type].to_s.eql?('function')
            @function_groups[code.to_sym].merge!(tmp[code.to_sym])
          else
            @menus[code.to_sym].merge!(tmp[code.to_sym])
          end
        end
      end
    end

    #处理权限
    def function(name, hash, options={})
      @functions ||= {}
      if @functions.keys.include?(name.to_sym)
        exists_permissions  = @functions[name.to_sym][:permissions]
        permissions = hash.dup
        exists_permissions.each do |controller,actions|
          if(hash[controller])
            exists_permissions[controller] += hash[controller]
            exists_permissions[controller].uniq!
            permissions.delete(controller)
          end
        end
        exists_permissions.merge!(permissions)
      else
        @functions.merge!({name.to_sym=>{:permissions=>hash,:options=>options}})
      end
    end

    def mapped_menus
      @menus
    end

    def mapped_function_groups
      @function_groups
    end

    def mapped_functions
      @functions
    end

  end
end