Rails.application.routes.draw do
  scope :module => "fm" do
    #file_managements
    match '/om_file_managements(/index)(.:format)' => "om_file_managements#index", :via => :get
    match '/om_file_managements/:id/edit(.:format)' => "om_file_managements#edit", :via => :get
    match '/om_file_managements/:id/update(.:format)' => "om_file_managements#update"
    match '/om_file_managements/new(.:format)' => "om_file_managements#new"
    match '/om_file_managements/batch_new(.:format)' => "om_file_managements#batch_new"
    match '/om_file_managements/create(.:format)' => "om_file_managements#create", :via => :post
    match '/om_file_managements/batch_create(.:format)' => "om_file_managements#batch_create", :via => :post
    match '/om_file_managements/get_data(.:format)' => "om_file_managements#get_data"
    match '/om_file_managements/:id/show(.:format)' => "om_file_managements#show", :via => :get
    match '/om_file_managements/:id/download(.:format)' => "om_file_managements#download", :via => :get
    match '/om_file_managements/:id/destroy(.:format)' => "om_file_managements#destroy"
    match '/om_file_managements/:id/get_version_files(.:format)' => "om_file_managements#get_version_files"
    match '/om_file_managements/:id/get_version_files(.:format)' => "om_file_managements#get_version_files"
    match '/om_file_managements/:id/version_details(.:format)' => "om_file_managements#version_details"
    match '/om_file_managements/:id/download_data(.:format)' => "om_file_managements#download_data"
    match '/om_file_managements/:id/remove_version_file(.:format)' => "om_file_managements#remove_version_file"


    match '/om_attachments/:source_id/destroy_attachment/:id(.:format)' => "om_attachments#destroy_attachment", :via => :delete
    match '/om_attachments/create_attachment(.:format)' => "om_attachments#create_attachment", :via => :post
    match '/om_attachments/:id/download(.:format)' => "om_attachments#download"

    resources :om_attachment_folders ,:except=>'show' do
      collection do
        get 'get_data'
        get 'get_folders_tree'
      end
    end
  end
end