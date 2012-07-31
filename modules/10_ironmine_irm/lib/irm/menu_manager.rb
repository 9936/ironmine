module Irm::MenuManager
     class << self

      # 系统中所有菜单，以HASH形式保存
      def menus
        items[:menus]
      end

      def permissions
        items[:permissions]
      end

      def function_groups
        items[:function_groups]
      end

      def public_functions
        items[:public_functions]
      end

      def login_functions
        items[:login_functions]
      end

      # 所有权限对应的上级菜单，以HASH形式保存
      def function_group_menus
        items[:function_group_menus]
      end


      def menu_menus
        items[:menu_menus]
      end

      #初始化菜单和权限缓存
      def reset_menu
        # 生成菜单缓存
        prepare_menu_cache
        # 生成权限缓存
        prepare_permission_cache
        # 初始化权限对应的菜单
        prepare_menu_hierarchy

        prepare_function_groups
        #rescue =>text
        #  puts("Init menu error:#{text}")
      end

      # =====================================生成菜单缓存===============================================
      def prepare_menu_cache
        menus = Irm::Menu.enabled
        menus_cache = {}
        menus.each do |m|
          # 子菜单项
          tmp_menu_entries = m.menu_entries.where("sub_menu_id IS NOT NULL AND sub_menu_id!=''").order(:display_sequence)
          menu_entries = []
          tmp_menu_entries.each do |tm|
            data = {:menu_entry_id=>tm.id,:sub_menu_id=>tm.sub_menu_id,:display_sequence=>tm.display_sequence}
            tm.menu_entries_tls.each do |mt|
              data.merge!({mt.language.to_sym=>{:name=>mt.name,:description=>mt.description}})
            end
            menu_entries<<data
          end
          # 子功能组项
          tmp_function_group_entries = m.menu_entries.where("(sub_menu_id IS NULL OR sub_menu_id='') AND (sub_function_group_id IS NOT NULL AND sub_function_group_id!='')").order(:display_sequence)
          function_group_entries = []
          tmp_function_group_entries.each do |tp|
            data = {:menu_entry_id=>tp.id,:sub_function_group_id=>tp.sub_function_group_id,:display_sequence=>tp.display_sequence}
            tp.menu_entries_tls.each do |mt|
              data.merge!({mt.language.to_sym=>{:name=>mt.name,:description=>mt.description}})
            end
            function_group_entries<<data
          end

          menu_data = {:menu_entries=>menu_entries,
                       :function_group_entries=>function_group_entries,
                       :id=>m.id
                       }

          menus_cache.merge!({m.id=>menu_data})
        end

        map do |m|
          m.merge!({:menus=>menus_cache})
        end
      end


      # =====================================生成权限缓存===============================================
      def prepare_permission_cache
        permissions = Irm::Permission.all
        public_functions_cache = Irm::Function.where(:public_flag=>Irm::Constant::SYS_YES).collect{|f| f.id}
        login_functions_cache = Irm::Function.where(:login_flag=>Irm::Constant::SYS_YES).collect{|f| f.id}
        permissions_cache = {}
        permissions.each do |p|
          permission_key = Irm::Permission.url_key(p.controller,p.action)
          if(permissions_cache[permission_key])
            permissions_cache[permission_key]+=[p.function_id]
          else
            permissions_cache[permission_key]=[p.function_id]
          end
        end

        map do |m|
          m.merge!({:permissions=>permissions_cache,:public_functions=>public_functions_cache,:login_functions=>login_functions_cache})
        end
      end



      def prepare_function_groups
        function_groups_cache = {}
        Irm::FunctionGroup.visitable.enabled.each{|fg| function_groups_cache.merge!(fg.id=>{:controller=>fg.controller,:action=>fg.action})}
        map do |m|
          m.merge!({:function_groups=>function_groups_cache})
        end
      end

      # =====================================生成权限的上层菜单，及菜单的上层菜单缓存===============================================
       # 生成权限对应的菜单列表
      def prepare_menu_hierarchy
        function_group_menus_cache = {}
        menu_menus_cache = {}
        map do |m|
          m.merge!({:function_group_menus => function_group_menus_cache,:menu_menus => menu_menus_cache})
        end
        top_menu= Irm::Menu.top_menu.collect{|m| m.id}
        top_menu.each do |m|
          expand_function_group([m])
        end
      end

      # 递归寻找菜单下的权限
      # 展开权限
      # menu_path 菜单路径
      def expand_function_group(menu_path)
        # 复制路径
        temp_menu_path = menu_path.dup
        # 取得当前菜单编码
        current_menu_id = temp_menu_path.last
        # 取得当前菜单
        current_menu = menus[current_menu_id]
        return unless current_menu

        current_menu[:function_group_entries].each do |fge|
          merge_function_group_menu({:key=>fge[:sub_function_group_id],:path=>temp_menu_path})
        end
        current_menu[:menu_entries].each do |me|
          if(menus[me[:sub_menu_id]].nil?)
            Rails.logger.warn("Not exists menu:#{me[:sub_menu_id]},Please check!")
            next
          end
          merge_menu_menu({:key=>me[:sub_menu_id],:path=>temp_menu_path})
          expand_function_group(temp_menu_path+[me[:sub_menu_id]])
        end
      end

      # 存储权限菜单数据
      def merge_function_group_menu(fgm)
        if(fgm[:key])
          if function_group_menus[fgm[:key]]
            function_group_menus[fgm[:key]].push(fgm[:path])
          else
            function_group_menus.merge!({fgm[:key]=>[fgm[:path]]})
          end
        end
      end

      # 存储权限菜单数据
      def merge_menu_menu(mm)
        if(mm[:key])
          if menu_menus[mm[:key]]
            menu_menus[mm[:key]].push(mm[:path])
          else
            menu_menus.merge!({mm[:key]=>[mm[:path]]})
          end
        end
      end


      #=================================取得当前用户可以访问的菜单和权限==============================================
      # 供外部调用
      # 通过菜单编码取得子菜单项
      # 在返回子项前进行菜单子项的权限验证
      # must_permission_code 表示entry的permission_code不能为空，如果为空使用IRM_SETTING_COMMON填充
      def sub_entries_by_menu(menu_code_or_id,is_id=true)
        sub_entries = []
        menu_id = nil
        if is_id
          menu_id = menu_code_or_id
        else
          code_menu = Irm::Menu.where(:code=>menu_code_or_id).first
          menu_id = code_menu.id if code_menu
        end
        menu = menus[menu_id]
        return sub_entries unless menu
        menu[:menu_entries].each do |me|
          if(menus[me[:sub_menu_id]].nil?)
            Rails.logger.warn("Not exists menu:#{me[:sub_menu_id]} ,Please check!")
            next
          end
          sub_menu = menus[me[:sub_menu_id]]
          entries_options = {:menu_entry_id=>me[:menu_entry_id],
                             :menu_id => me[:sub_menu_id],
                             :entry_type=>"MENU",
                             :display_sequence => me[:display_sequence],
                             :name=>me[::I18n.locale.to_sym][:name],
                             :description=>me[::I18n.locale.to_sym][:description]
                            }
            # 确定当前子菜单项是否可显示
            show_options = menu_showable(me)

            if show_options
              show_options = {:controller=>"irm/setting",:action=>"common"}
              sub_entries<< entries_options.merge!(show_options)
            end

        end
        menu[:function_group_entries].each do |fge|
          entries_options = {:menu_entry_id=>fge[:menu_entry_id],
                             :function_group_id => fge[:sub_function_group_id],
                             :entry_type=>"FUNCTION_GROUP",
                             :display_sequence => fge[:display_sequence],
                             :name=>fge[::I18n.locale.to_sym][:name],
                             :description=>fge[::I18n.locale.to_sym][:description]
                            }
          if function_groups[fge[:sub_function_group_id]]
            entries_options.merge!(function_groups[fge[:sub_function_group_id]])
          else
            next
          end
          sub_entries<< entries_options if Irm::PermissionChecker.allow_to_url?({:controller=>entries_options[:controller],:action=>entries_options[:action]})
        end
        sub_entries.sort {|x,y| x[:display_sequence] <=> y[:display_sequence] } 
      end

      # 供外部调用
      # 确定菜单是否可显示
      # 只要菜单下有一个可以显示的权限，则表示需要显示该菜单
      def menu_showable(menu_entry)
          menu = menus[menu_entry[:sub_menu_id]]
          if menu
            menu[:menu_entries].each do |me|
              showable = menu_showable(me)
              return showable if showable
            end

            menu[:function_group_entries].each do |fge|
              if function_groups[fge[:sub_function_group_id]]&&Irm::PermissionChecker.allow_to_url?(function_groups[fge[:sub_function_group_id]])
                return function_groups[fge[:sub_function_group_id]]
              end
            end

          end
          false
      end

      #=================================end 取得当前用户可以访问的菜单和权限==============================================

      #通过权限链接取得菜单列表
      def parent_menus_by_permission(options={},top_menu=nil)
        permission_key = Irm::Permission.url_key(options[:page_controller],options[:page_action])
        parent_menus =  permission_menus[permission_key]
        if(!parent_menus)
          permission_key =   Irm::Permission.url_key(options[:page_controller],"index")
          parent_menus =  permission_menus[permission_key]
        end
        # 如果没有对应的菜单，则返回空数组
        return [] unless parent_menus

        allowed_menus = parent_menus

        if !top_menu.nil?
          allowed_menus.each do |pms|
            return pms.dup if pms.include?(top_menu)
          end
        end
        allowed_menus.first
      end

      # 通过菜单取得上层菜单列表
      def parent_menus_by_menu(menu_id,top_menu_id=nil)
        parent_menus = menu_menus[menu_id]
        return [] unless parent_menus&&parent_menus.size>0
        allowed_menus = parent_menus||[]

        return [] unless allowed_menus.size>0
        if top_menu_id.present?
          allowed_menus.each do |pms|
            return pms.dup if pms.include?(top_menu_id)
          end
        end
        allowed_menus.first.dup
      end


      # 判断是否为菜单
      def parent_menu?(parent,child)
        menu_menus[child].detect{|i| i.include?(parent)}
      end



      #将数据加载至内存
      def map
        @items =Ironmine::STORAGE.get(:menu_manager_items)||{}
        if block_given?
          yield @items
        end
        Ironmine::STORAGE.put(:menu_manager_items,@items)
      end

      # 从内存中读取数据
      def items
        Ironmine::STORAGE.get(:menu_manager_items)||{}
      end
      
      private :map,:items
    end
end