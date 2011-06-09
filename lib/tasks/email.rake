namespace :irm do
  desc "(For Ironmine)Check and Sync Business Object ."
  task :receive_mail => :environment do
    Irm::MailManager.receive_mail
  end
end