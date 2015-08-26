#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  #=================================START:FILES_MANAGEMENT=================================
  map.function_group :om_files_management, {
      :en => {:name => "O&M Files Management", :description => "O&M Files Management"},
      :zh => {:name => "O&M文件管理", :description => "O&M文件管理"},
      :ja => {:name => "O&M Files Management", :description => "O&M Files Management"}, }
  map.function_group :om_files_management, {
                                          :zone_code => "OM_FILE_MANAGEMENT",
                                          :controller => "fm/om_file_managements",
                                          :action => "index"}
  map.function_group :om_files_management, {
      :children => {
          :fm_self_files_management => {
               :en => {:name => "Self Files Management", :description => "Self Files Management"},
               :zh => {:name => "Self文件管理", :description => "Self文件管理"},
               :ja => {:name => "Self Files Management", :description => "Self Files Management"},
               :default_flag => "N",
               :login_flag => "N",
               :public_flag => "N",
               "fm/om_file_managements" => ["batch_create", "create", "destroy", "edit", "get_data", "get_version_files",
                                          "version_details", "download_data", "remove_version_file", "index", "new", "show", "update", "download"]
          },
          :fm_files_management => {
              :en => {:name => "Files Management", :description => "Files Management"},
              :zh => {:name => "文件管理", :description => "文件管理"},
              :ja => {:name => "Files Management", :description => "Files Management"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "fm/om_file_managements" => ["batch_create", "create", "destroy", "edit", "get_data", "get_version_files",
                                         "version_details", "download_data", "remove_version_file", "index", "new", "show", "update", "download"]
          },
          :fm_download_files => {
              :en => {:name => "Download Files", :description => "Download Files"},
              :zh => {:name => "下载文件", :description => "下载文件"},
              :ja => {:name => "Download Files", :description => "Download Files"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "fm/om_attachment_folders" => ["get_data", "get_folders_tree", "api_child_nodes"],
              "fm/om_file_managements" => ["get_data", "get_version_files", "version_details", "download_data", "download", "index", "show"]
          },
          :fm_file_folders_management => {
              :en => {:name => "File Folders Management", :description => "File Folders Management"},
              :zh => {:name => "文件夹管理", :description => "文件夹管理"},
              :ja => {:name => "File Folders Management", :description => "File Folders Management"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "fm/om_attachment_folders" => ["index", "show", "new", "edit", "create", "update", "destroy", "get_data", "get_folders_tree", "api_child_nodes"]
          },
          :fm_file_folders_read_only => {
              :en => {:name => "File Folders Read Only", :description => "File Folders Read Only"},
              :zh => {:name => "文件夹只读", :description => "文件夹只读"},
              :ja => {:name => "File Folders Read Only", :description => "File Folders Read Only"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "fm/om_attachment_folders" => ["index", "show", "get_data", "get_folders_tree", "api_child_nodes"]
          }
      }
  }
end