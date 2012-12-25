module Irm::MailSettingsHelper

  def available_authentication
    authentications = []
    authentications << [:login, :login]
    authentications << [:plain, :plain]
  end
end