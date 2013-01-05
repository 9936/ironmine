module Irm::MailSettingsHelper

  def available_authentication
    authentications = []
    authentications << [:login, :login]
    authentications << [:plain, :plain]
    authentications << [:cram_md5, :cram_md5]
  end
end