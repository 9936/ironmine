# 修改session store,在get
module Fwk::SessionStore
  def self.included(base)
    base.class_eval do
      private
      def get_session(env, sid)
        ActiveRecord::Base.silence do
          unless sid and session = @@session_class.find_by_session_id(sid)
            # If the sid was nil or if there is no pre-existing session under the sid,
            # force the generation of a new sid and associate a new session associated with the new sid
            sid = generate_sid
            session = @@session_class.new(:session_id => sid, :data => {})
          end
          env[SESSION_RECORD_KEY] = session
          [sid, {:session_id => sid}.merge(session.data)]
        end
      end
    end
  end
end