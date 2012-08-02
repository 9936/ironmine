module Fwk::Sunspot
  class DelayedJobSessionProxy < Sunspot::SessionProxy::AbstractSessionProxy

    attr_reader :original_session

    delegate :config, :delete_dirty?, :dirty?,
             :new_search, :search,
             :new_more_like_this, :more_like_this,
             :remove, :remove!,
             :remove_by_id, :remove_by_id!,
             :remove_all, :remove_all!,
             :batch, :commit, :commit_if_delete_dirty, :commit_if_dirty,
             :index!, :to => :session

    def initialize(session)
      @original_session = session
    end

    alias_method :session, :original_session

    def index(*objects)
      objects.flatten.compact.each do |object|
        Delayed::Job.enqueue Fwk::Jobs::IndexingJob.new(object.class.name, object.id)
      end
    end

  end

end

