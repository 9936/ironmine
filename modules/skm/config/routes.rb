Rails.application.routes.draw do
  scope :module => "skm" do
      #entry_statuses
      match '/entry_statuses(/index)(.:format)' => "entry_statuses#index", :via => :get
      match '/entry_statuses/:id/edit(.:format)' => "entry_statuses#edit", :via => :get
      match '/entry_statuses/:id(.:format)' => "entry_statuses#update", :via => :put
      match '/entry_statuses/new(.:format)' => "entry_statuses#new", :via => :get
      match '/entry_statuses/create(.:format)' => "entry_statuses#create", :via => :post
      match '/entry_statuses/get_data(.:format)' => "entry_statuses#get_data"
      match '/entry_statuses/:id/show(.:format)' => "entry_statuses#show", :via => :get
      #entry_elements
      match '/entry_template_elements(/index)(.:format)' => "entry_template_elements#index", :via => :get
      match '/entry_template_elements/:id/edit(.:format)' => "entry_template_elements#edit", :via => :get
      match '/entry_template_elements/:id(.:format)' => "entry_template_elements#update", :via => :put
      match '/entry_template_elements/new(.:format)' => "entry_template_elements#new", :via => :get
      match '/entry_template_elements/create(.:format)' => "entry_template_elements#create", :via => :post
      match '/entry_template_elements/get_data(.:format)' => "entry_template_elements#get_data"
      match '/entry_template_elements/:id/show(.:format)' => "entry_template_elements#show", :via => :get
      #entry_templates
      match '/entry_templates(/index)(.:format)' => "entry_templates#index", :via => :get
      match '/entry_templates/:id/edit(.:format)' => "entry_templates#edit", :via => :get
      match '/entry_templates/:id(.:format)' => "entry_templates#update", :via => :put
      match '/entry_templates/new(.:format)' => "entry_templates#new", :via => :get
      match '/entry_templates/create(.:format)' => "entry_templates#create", :via => :post
      match '/entry_templates/get_data(.:format)' => "entry_templates#get_data"
      match '/entry_templates/get_data_rest(.:format)' => "entry_templates#get_data_rest"
      match '/entry_templates/:id/show(.:format)' => "entry_templates#show", :via => :get
      match '/entry_templates/:template_id/:element_id/remove_element(.:format)' => "entry_templates#remove_element", :via => :get
      match '/entry_templates/:template_id/add_elements(.:format)' => "entry_templates#add_elements", :via => :post
      match '/entry_templates/:template_id/select_elements(.:format)' => "entry_templates#select_elements", :via => :get
      match '/entry_templates/:template_id/get_owned_elements_data(.:format)' => "entry_templates#get_owned_elements_data", :via => :get
      match '/entry_templates/:template_id/get_available_elements(.:format)' => "entry_templates#get_available_elements", :via => :get
      match '/entry_templates/:template_id:element_id/up_element(.:format)' => "entry_templates#up_element", :via => :get
      match '/entry_templates/:template_id:element_id/down_element_elements(.:format)' => "entry_templates#down_element", :via => :get
      match '/entry_templates/:id/edit_detail(.:format)' => "entry_templates#edit_detail", :via => :get
      match '/entry_templates/:detail_id/update_detail(.:format)' => "entry_templates#update_detail"
      #entry_headers
      match '/entry_headers(/index)(.:format)' => "entry_headers#index", :via => :get
      match '/entry_headers/:id/edit(.:format)' => "entry_headers#edit", :via => :get
      match '/entry_headers/portlet(.:format)' => "entry_headers#portlet", :via => :get
      match '/entry_headers/:id/update(.:format)' => "entry_headers#update", :via => [:put, :post]
      match '/entry_headers/new(.:format)' => "entry_headers#new"
      match '/entry_headers/create(.:format)' => "entry_headers#create", :via => :post
      match '/entry_headers/get_data(.:format)' => "entry_headers#get_data"
      match '/entry_headers/:doc_number/get_history_entries_data(.:format)' => "entry_headers#get_history_entries_data"
      match '/entry_headers/:id/show(.:format)' => "entry_headers#show", :via => :get
      match '/entry_headers/new_step_1(.:format)' => "entry_headers#new_step_1", :via => :get
      match '/entry_headers/new_step_2(.:format)' => "entry_headers#new_step_2", :via => :get
      match '/entry_headers/new_step_3(.:format)' => "entry_headers#new_step_3", :via => :get
      match '/entry_headers/new_step_4(.:format)' => "entry_headers#new_step_4", :via => :get
      match '/entry_headers/new_step_type_select(.:format)' => "entry_headers#new_step_type_select", :via => :get
      match '/entry_headers/new_step_video_upload(.:format)' => "entry_headers#new_step_video_upload", :via => :get
      match '/entry_headers/video_create(.:format)' => "entry_headers#video_create", :via => :post
      match '/entry_headers/:id/video_show(.:format)' => "entry_headers#video_show", :via => :get
      match '/entry_headers/:id/video_edit(.:format)' => "entry_headers#video_edit", :via => :get
      match '/entry_headers/:id/video_update(.:format)' => "entry_headers#video_update", :via => :put
      match '/entry_headers/:source_id/add_relation(.:format)' => "entry_headers#add_relation", :via => :post
      match '/entry_headers/remove_relation(.:format)' => "entry_headers#remove_relation"
      match '/entry_headers/:id/new_relation(.:format)' => "entry_headers#new_relation", :via => :get
      match '/entry_headers/create_relation(.:format)' => "entry_headers#create_relation", :via => :post
      match '/entry_headers/:id/knowledge_details(.:format)' => "entry_headers#knowledge_details", :via => :get
      match '/entry_headers/:id/reset_approve(.:format)' => "entry_headers#reset_approve", :via => :post

      match '/entry_headers/index_search(.:format)' => "entry_headers#index_search", :via => :post
      match '/entry_headers/index_search_get_data(.:format)' => "entry_headers#index_search_get_data"
      match '/entry_headers/:person_id/my_favorites_data' => "entry_headers#my_favorites_data"
      match '/entry_headers/:person_id/my_favorites' => "entry_headers#my_favorites", :via => :get
      match '/entry_headers/:person_id/my_unpublished_data' => "entry_headers#my_unpublished_data"
      match '/entry_headers/:person_id/my_unpublished' => "entry_headers#my_unpublished", :via => :get
      match '/entry_headers/wait_my_approve_data' => "entry_headers#wait_my_approve_data"
      match '/entry_headers/wait_my_approve' => "entry_headers#wait_my_approve", :via => :get
      match '/entry_headers/approve_knowledge(.:format)' => "entry_headers#approve_knowledge", :via => :post
      match '/entry_headers/:person_id/:id/add_favorites' => "entry_headers#add_favorites", :via => :get
      match '/entry_headers/data_grid(.:format)' => "entry_headers#data_grid", :via => :get
      match '/entry_headers/my_favorites(.:format)' => "entry_headers#my_favorites", :via => :get
      match '/entry_headers/my_unpublished(.:format)' => "entry_headers#my_unpublished", :via => :get
      match '/entry_headers/remove_favorite(.:format)' => "entry_headers#remove_favorite", :via => :get
      match '/entry_headers/my_drafts(.:format)' => "entry_headers#my_drafts", :via => :get
      match '/entry_headers/:person_id/my_drafts_data' => "entry_headers#my_drafts_data"
      match '/entry_headers/new_from_icm_request' => "entry_headers#new_from_icm_request", :via => :get
      match '/entry_headers/create_from_icm_request' => "entry_headers#create_from_icm_request", :via => :post
      match '/entry_headers/:att_id/remove_exits_attachment_during_create' => "entry_headers#remove_exits_attachment_during_create", :via => :get
      match '/entry_headers/:att_id/:entry_header_id/remove_exits_attachment' => "entry_headers#remove_exits_attachment", :via => :get
      #entry_reports
      match '/entry_reports/rpt_entry_submit_summary(.:format)'=>"entry_reports#rpt_entry_submit_summary"
      match '/entry_reports(/index)(.:format)'=>"entry_reports#index"

      match '/entry_reports/get_rpt_apply_data(.:format)' => "entry_reports#get_rpt_apply_data"
      match '/entry_reports/rpt_entry_apply_summary(.:format)'=>"entry_reports#rpt_entry_apply_summary"

      match '/entry_reports/rpt_search_history_summary(.:format)' => "entry_reports#rpt_search_history_summary"
      match '/entry_reports/get_search_history_data(.:format)'=>"entry_reports#get_search_history_data"

      match '/entry_reports/rpt_entry_show_history(.:format)' => "entry_reports#rpt_entry_show_history"
      match '/entry_reports/get_rpt_show_data(.:format)'=>"entry_reports#get_rpt_show_data"

      match '/entry_reports/rpt_entry_history_summary(.:format)' => "entry_reports#rpt_entry_history_summary"

      #file_managements
      match '/file_managements(/index)(.:format)' => "file_managements#index", :via => :get
      match '/file_managements/:id/edit(.:format)' => "file_managements#edit", :via => :get
      match '/file_managements/:id/update(.:format)' => "file_managements#update"
      match '/file_managements/new(.:format)' => "file_managements#new"
      match '/file_managements/batch_new(.:format)' => "file_managements#batch_new"
      match '/file_managements/create(.:format)' => "file_managements#create", :via => :post
      match '/file_managements/batch_create(.:format)' => "file_managements#batch_create", :via => :post
      match '/file_managements/get_data(.:format)' => "file_managements#get_data"
      match '/file_managements/:id/show(.:format)' => "file_managements#show", :via => :get
      match '/file_managements/destroy(.:format)' => "file_managements#destroy"
      match '/file_managements/:id/get_version_files(.:format)' => "file_managements#get_version_files"

      #skm_setting
      match '/skm_settings(/index)(.:format)' => "settings#index", :via => :get
      match '/skm_settings/edit(.:format)' => "settings#edit", :via => :get
      match '/skm_settings/update(.:format)' => "settings#update"

      #skm_columns
      match '/skm_columns(/index)(.:format)' => "columns#index", :via => :get
      match '/skm_columns/new(.:format)' => "columns#new", :via => :get
      match '/skm_columns/create(.:format)' => "columns#create", :via => :post
      match '/skm_columns/:id/edit(.:format)' => "columns#edit", :via => :get
      match '/skm_columns/:id/update(.:format)' => "columns#update", :via => :put
      match '/skm_columns/get_columns_data(.:format)' => "columns#get_columns_data", :via => :get

      #skm_channels
      match '/channels(/index)(.:format)' => "channels#index", :via => :get
      match '/channels/:id/edit(.:format)' => "channels#edit", :via => :get
      match '/channels/:id(.:format)' => "channels#update", :via => :put
      match '/channels/new(.:format)' => "channels#new", :via => :get
      match '/channels/create(.:format)' => "channels#create", :via => :post
      match '/channels/get_data(.:format)' => "channels#get_data"
      match '/channels/:id/show(.:format)' => "channels#show", :via => :get
      match '/channels/get_all_columns_data(.:format)' => "channels#get_all_columns_data", :via => :get
      match '/channels/:id/multilingual_edit(.:format)' => "channels#multilingual_edit", :via => :get
      match '/channels/:id/multilingual_update(.:format)' => "channels#multilingual_update", :via => :put
      match '/channels/:group_id/get_owned_channels(.:format)' => "channels#get_owned_channels"
      match '/channels/:group_id/get_ava_channels(.:format)' => "channels#get_ava_channels"
      match '/channels/:id/get_owned_groups_data(.:format)' => "channels#get_owned_groups_data", :via => :get
      match '/channels/:id/get_ava_groups_data(.:format)' => "channels#get_ava_groups_data", :via => :get
      match '/channels/:id/new_groups(.:format)' => "channels#new_groups", :via => :get
      match '/channels/:id/create_groups(.:format)' => "channels#create_groups", :via => :post
      match '/channels/:group_id/:channel_id/remove_group(.:format)' => "channels#remove_group"
      match '/channels/:id/get_approvals_data(.:format)' => "channels#get_approvals_data"
      match '/channels/:id/get_owned_approvals_data(.:format)' => "channels#get_owned_approvals_data", :via => :get
      match '/channels/:id/new_approvals(.:format)' => "channels#new_approvals", :via => :get
      match '/channels/:id/create_approvals(.:format)' => "channels#create_approvals", :via => :post
      match '/channels/:person_id/:channel_id/remove_approval(.:format)' => "channels#remove_approval"

      #wiki_templates
      match '/wiki_templates(/index)(.:format)' => "wiki_templates#index", :via => :get
      match '/wiki_templates/:id/edit(.:format)' => "wiki_templates#edit", :via => :get
      match '/wiki_templates/:id/update(.:format)' => "wiki_templates#update", :via => :put
      match '/wiki_templates/new(.:format)' => "wiki_templates#new", :via => :get
      match '/wiki_templates/get_data(.:format)' => "wiki_templates#get_data", :via => :get
      match '/wiki_templates/create(.:format)' => "wiki_templates#create", :via => :post
      match '/wiki_templates/get_data(.:format)' => "wiki_templates#get_data"
      match '/wiki_templates/:id/show(.:format)' => "wiki_templates#show", :via => :get
      match '/wiki_templates/preview(.:format)' => "wiki_templates#preview", :via => [:post,:put]
      match '/wiki_templates/:id/sample(.:format)' => "wiki_templates#sample", :via => :get

      #wikis
      match '/wikis(/index)(.:format)' => "wikis#index", :via => :get
      match '/wikis/:id/edit(.:format)' => "wikis#edit", :via => :get
      match '/wikis/:id/edit_chapter(.:format)' => "wikis#edit_chapter", :via => :get
      match '/wikis/:id/update_chapter(.:format)' => "wikis#update_chapter", :via => :put
      match '/wikis/:id/update(.:format)' => "wikis#update", :via => :put
      match '/wikis/new(.:format)' => "wikis#new", :via => :get
      match '/wikis/new_word(.:format)' => "wikis#new_word", :via => :get
      match '/wikis/create_word(.:format)' => "wikis#create_word", :via => :post
      match '/wikis/get_data(.:format)' => "wikis#get_data", :via => :get
      match '/wikis/create(.:format)' => "wikis#create", :via => :post
      match '/wikis/get_data(.:format)' => "wikis#get_data"
      match '/wikis/:id/show(.:format)' => "wikis#show", :via => :get
      match '/wikis/preview(.:format)' => "wikis#preview", :via => [:post,:put]
      match '/wikis/:id/history(.:format)' => "wikis#history", :via => :get
      match '/wikis/:id/compare(.:format)' => "wikis#compare", :via => [:get,:post]
      match '/wikis/:id/revert(.:format)' => "wikis#revert", :via => [:post]
      #books
      match '/books(/index)(.:format)' => "books#index", :via => :get
      match '/books/:id/edit(.:format)' => "books#edit", :via => :get
      match '/books/:id/update(.:format)' => "books#update", :via => :put
      match '/books/new(.:format)' => "books#new", :via => :get
      match '/books/get_data(.:format)' => "books#get_data", :via => :get
      match '/books/create(.:format)' => "books#create", :via => :post
      match '/books/get_data(.:format)' => "books#get_data"
      match '/books/:id/show(.:format)' => "books#show", :via => :get
      match '/books/:id/publish(.:format)' => "books#publish", :via => :get
      match '/book_wikis/:book_id/create(.:format)' => "book_wikis#create", :via => :post
      match '/book_wikis/:id/destroy(.:format)' => "book_wikis#destroy", :via => :delete
      match '/book_wikis/:book_id/order(.:format)' => "book_wikis#order", :via => :post
    end
end