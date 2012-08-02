module Skm::Gollum::Page
  def self.included(base)
      base.class_eval do
        attr_accessor :attachments
        attr_accessor :mode
      end
    end
end