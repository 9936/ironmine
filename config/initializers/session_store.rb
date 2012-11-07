# Be sure to restart your server when you modify this file.

#Ironmine::Application.config.session_store :cookie_store, :key => '_ironmine_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
#Ironmine::Application.config.session_store :active_record_store
Ironmine::Application.config.session_store :cookie_store, :key => '_new_ironmine_session_cookie'
