Ironmine::Application.routes.draw do




  scope :module => "csi" do
    #surveys
    match '/surveys(/index)(.:format)' => "surveys#index", :via => :get
    match '/surveys/get_data(.:format)' => "surveys#get_data"
    match '/surveys/:id/edit(.:format)' => "surveys#edit", :via => :get
    match '/surveys/:id(.:format)' => "surveys#update", :via => :put
    match '/surveys/new(.:format)' => "surveys#new", :via => :get
    match '/surveys/:id/reply(.:format)' => "surveys#reply", :via => :get
    match '/surveys/create(.:format)' => "surveys#create", :via => :post
    match '/surveys/password'=> "surveys#password", :via => :post
    match '/surveys/create_result' => "surveys#create_result", :via => :post
    match '/surveys/thanks(.:format)' => "surveys#thanks", :via => :get
    match '/surveys/:id/show_result(.:format)' => "surveys#show_result", :via => :get
    match '/surveys/:id/export_result(.:format)' => "surveys#export_result", :via => :get
    match '/surveys/test(.:format)' => "surveys#test", :via => :get
    match '/surveys/:id/survey_report(.:format)' => "surveys#survey_report", :via => :get
    match '/surveys/get_survey_report(.:format)' => "surveys#get_survey_report", :via => :get
    match '/surveys/:id/show(.:format)' => "surveys#show", :via => :get
    match '/surveys/:id/active(.:format)' => "surveys#active", :via => :get
    match '/surveys/:id/show_reply(.:format)' => "surveys#show_reply", :via => :get



    #survey_subjects
    match '/surveys/:survey_id/survey_subjects(/index)(.:format)' => "survey_subjects#index", :via => :get
    match '/surveys/:survey_id/survey_subjects/get_data(.:format)' => "survey_subjects#get_data"
    match '/surveys/:survey_id/survey_subjects/:id/edit(.:format)' => "survey_subjects#edit", :via => :get
    match '/surveys/:survey_id/survey_subjects/:id(.:format)' => "survey_subjects#update", :via => :put
    match '/surveys/:survey_id/survey_subjects/new(.:format)' => "survey_subjects#new", :via => :get
    match '/surveys/:survey_id/survey_subjects/:id(.:format)' => "survey_subjects#show", :via => :get
    match '/surveys/:survey_id/survey_subjects/create(.:format)' => "survey_subjects#create", :via => :post
    match '/surveys/:survey_id/survey_subjects/:id/destroy(.:format)' => "survey_subjects#destroy"
    #survey_ranges
    match '/surveys/:survey_id/survey_ranges/get_data(.:format)' => "survey_ranges#get_data"
    match '/surveys/:survey_id/survey_ranges(/index)(.:format)' => "survey_ranges#index", :via => :get
    match '/surveys/:survey_id/survey_ranges/:id/edit(.:format)' => "survey_ranges#edit", :via => :get
    match '/surveys/:survey_id/survey_ranges/:id(.:format)' => "survey_ranges#update", :via => :put
    match '/surveys/:survey_id/survey_ranges/new(.:format)' => "survey_ranges#new", :via => :get
    match '/surveys/:survey_id/survey_ranges/create(.:format)' => "survey_ranges#create", :via => :post
    match '/surveys/:survey_id/survey_ranges/:id(.:format)'=>"survey_ranges#destroy",:via=>:delete
    match '/surveys/:survey_id/survey_ranges/:id(.:format)' => "survey_ranges#show", :via => :get

    match '/survey_responses/:survey_member_id/new'=>"survey_responses#new", :via => :get
    match '/survey_responses/:survey_member_id/create'=>"survey_responses#create", :via => :post
    match '/survey_responses/:survey_member_id/fill_password'=>"survey_responses#fill_password", :via => :get
    match '/survey_responses/:survey_member_id/validate_password'=>"survey_responses#validate_password", :via => :put

    match '/survey_results/:id/statistics' => 'survey_results#statistics', :via => :get
    match '/survey_results/:id/export' => 'survey_results#export', :via => :get
    match '/survey_results/:id/list' => 'survey_results#list', :via => :get
    match '/survey_results/:id/get_data' => 'survey_results#get_data', :via => :get
    match '/survey_results/:id/show_response' => 'survey_results#show_response', :via => :get
    match '/survey_results/:id/show_input' => 'survey_results#show_input', :via => :get
  end

end
