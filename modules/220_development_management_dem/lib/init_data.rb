#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  map.menu :management_setting, {
      :en => {:name => "Setting Management ", :description => "Setting Management "},
      :zh => {:name => "管理设置", :description => "管理设置"},
      :children => {
          :user_management => {
              :type => "menu",
              :entry => {
                  :sequence => 10,
                  :en => {:name => "User Management", :description => "User Management"},
                  :zh => {:name => "管理用户", :description => "管理用户"},
              }},
          :organization_management => {
              :type => "menu",
              :entry => {
                  :sequence => 20,
                  :en => {:name => "Organization Information", :description => "Organization Information"},
                  :zh => {:name => "组织信息", :description => "组织信息"},
              }},
          :site_management => {
              :type => "menu",
              :entry => {
                  :sequence => 30,
                  :en => {:name => "Site Information", :description => "Site Information"},
                  :zh => {:name => "地点信息", :description => "地点信息"},
              }},
          :external_system_management => {
              :type => "menu",
              :entry => {
                  :sequence => 40,
                  :en => {:name => "External System", :description => "External System"},
                  :zh => {:name => "应用系统", :description => "应用系统"},
              }},
          :incident_management => {
              :type => "menu",
              :entry => {
                  :sequence => 50,
                  :en => {:name => "Incident Setting", :description => "Incident Setting"},
                  :zh => {:name => "事故管理", :description => "事故管理"},
              }},
          :knowledge_management => {
              :type => "menu",
              :entry => {
                  :sequence => 70,
                  :en => {:name => "Knowledge Base Setting", :description => "Knowledge Base Setting"},
                  :zh => {:name => "知识库管理", :description => "知识库管理"},
              }},
          :ldap_management => {
              :type => "menu",
              :entry => {
                  :sequence => 80,
                  :en => {:name => "Ldap Setting", :description => "Ldap Setting"},
                  :zh => {:name => "LDAP集成", :description => "LDAP集成"},
              }},
          :mail_management => {
              :type => "menu",
              :entry => {
                  :sequence => 90,
                  :en => {:name => "Mail&Communicate", :description => "Mail&Communicate"},
                  :zh => {:name => "邮件通信", :description => "邮件通信"},
              }},
          :monitor_management => {
              :type => "menu",
              :entry => {
                  :sequence => 100,
                  :en => {:name => "Moitor", :description => "Moitor"},
                  :zh => {:name => "监控", :description => "监控"},
              }},
          :bulletin_management => {
              :type => "menu",
              :entry => {
                  :sequence => 120,
                  :en => {:name => "Bulletn", :description => "Bulletin"},
                  :zh => {:name => "公告管理", :description => "公告管理"},
              }},
          :kanban_management => {
              :type => "menu",
              :entry => {
                  :sequence => 110,
                  :en => {:name => "Signboard", :description => "Signboard"},
                  :zh => {:name => "看板管理", :description => "看板管理"},
              }},
          :security_control => {
              :type => "menu",
              :entry => {
                  :sequence => 130,
                  :en => {:name => "Security Control", :description => "Security Control"},
                  :zh => {:name => "安全控制", :description => "安全控制"},
              }},
          :change_management => {
              :type => "menu",
              :entry => {
                  :sequence => 55,
                  :en => {:name => "Change Management", :description => "Change setting"},
                  :zh => {:name => "变更管理", :description => "变更相关设置与管理"},
              }},
          :config_management => {
              :type => "menu",
              :entry => {
                  :sequence => 56,
                  :en => {:name => "Config Management", :description => "Config Management"},
                  :zh => {:name => "配置管理", :description => "配置管理相关设置"},
              }},
          :dev_management => {
              :type => "menu",
              :entry => {
                  :sequence => 60,
                  :en => {:name => "Development Management", :description => "Development Management"},
                  :zh => {:name => "开发管理", :description => "开发管理"},
              }},
      }
  }

  map.menu :dev_management, {
      :en => {:name => "Development Management", :description => "Development Management"},
      :zh => {:name => "开发管理", :description => "开发管理"},
      :children => {
          :dem_dev_phase_template => {
              :type => "function",
              :entry => {
                  :sequence => 10,
                  :en => {:name => "Phase Templates", :description => "Phase Templates"},
                  :zh => {:name => "阶段模板", :description => "阶段模板"},
              }},
          :dem_project => {
              :type => "function",
              :entry => {
                  :sequence => 20,
                  :en => {:name => "Projects", :description => "Projects"},
                  :zh => {:name => "开发项目", :description => "开发项目"},
              }}
      }
  }

  map.function_group :dem_dev_phase_template, {
      :en => {:name => "Phase Templates", :description => "Phase Templates"},
      :zh => {:name => "阶段模板", :description => "阶段模板"}
  }
  map.function_group :dem_dev_phase_template, {
      :zone_code => "DEV_MAN",
      :controller => "dem/dev_phase_templates",
      :action => "index"}
  map.function_group :dem_dev_phase_template, {
      :children => {
          :phase_template => {
              :en => {:name => "Phase Templates", :description => "Phase Templates"},
              :zh => {:name => "阶段模板", :description => "阶段模板"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "dem/dev_phase_templates" => ["index", "new", "create", "edit", "update", "show", "get_data", "destroy"]
          }
      }
  }

  map.function_group :dem_project, {
      :en => {:name => "Projects", :description => "Projects"},
      :zh => {:name => "开发项目", :description => "开发项目"}
  }
  map.function_group :dem_project, {
      :zone_code => "DEV_MAN",
      :controller => "dem/projects",
      :action => "index"}
  map.function_group :dem_project, {
      :children => {
          :dem_project => {
              :en => {:name => "Projects", :description => "Projects"},
              :zh => {:name => "阶段模板", :description => "阶段模板"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "dem/projects" => ["index", "new", "create", "edit", "update", "show", "get_data", "destroy"]
          }
      }
  }


  #=================================START:Sales=================================
  map.function_group :dev_management, {
      :en => {:name => "Development Management", :description => "Development Management"},
      :zh => {:name => "开发管理", :description => "开发管理"}
  }
  map.function_group :dev_management, {
      :zone_code => "DEV_MAN",
      :controller => "dem/dev_managements",
      :action => "index"}
  map.function_group :dev_management, {
      :children => {
          :dev_management => {
              :en => {:name => "Development Management", :description => "Development Management"},
              :zh => {:name => "开发管理", :description => "开发管理"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "dem/dev_managements" => ["index", "new", "create", "edit", "update",
                                        "show", "get_data", "destroy", "create_phase"],
              "dem/dev_phases" => ["destroy"]

          }
      }
  }
  #=================================END:Sales=================================
end