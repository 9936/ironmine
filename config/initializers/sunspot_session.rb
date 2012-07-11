#sunspot_plus
#set the session to the delayed_job handler - this will send all model CRUD reindexing to delayed_job
require 'sunspot_rails'
#require 'sunspot_plus/session_proxy/delayed_job_session_proxy'
Sunspot.session = Sunspot::SessionProxy::DelayedJobSessionProxy.new(Sunspot.session)