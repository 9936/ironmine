Ironmine::Application.routes.draw do
  scope :module => "icm" do
    match 'incident_journals/:request_id/:sid/edit_additional_info(.:format)' => "incident_journals#edit_additional_info", :via => :get
    match 'incident_journals/:request_id/:sid/update_additional_info(.:format)' => "incident_journals#update_additional_info", :via => :put
  end
end