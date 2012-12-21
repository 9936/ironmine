class MailSettingsTestMailer < ActionMailer::Base
  default :from => Irm::MailManager.default_email_from

  def test_smtp(email)
    mail(to: email,:subject => "Test smtp settings.", :content_type => "text/plain", :body => "Successfully!!")
  end
end