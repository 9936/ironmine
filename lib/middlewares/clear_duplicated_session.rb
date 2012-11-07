module Middlewares
  class ClearDuplicatedSession

    def initialize(app)
      @app = app
    end

    def call(env)
      result = @app.call(env)

      if there_are_more_than_one_session_key_in_cookies?(env)
        delete_session_cookie_for_current_domain(env)
      end

      result
    end


    private

    def there_are_more_than_one_session_key_in_cookies?(env)
      entries = 0
      offset = 0
      while offset = env["HTTP_COOKIE"].to_s.index(get_session_key(env), offset)
        entries += 1
        offset += 1
      end
      entries > 1
    end


    # Sets expiration date = 1970-01-01 to the cookie, this way browser will
    # note the cookie is expired and will delete it
    def delete_session_cookie_for_current_domain(env)
      ::Rack::Utils.set_cookie_header!(
          env['action_controller.instance'].response.header, # contains response headers
          get_session_key(env), # gets the cookie session name, '_session_cookie' - for this example
          { :value => '', :path => '/', :expires => Time.at(0) }
      )
    end


    def get_session_key(env)
      env['rack.session'].instance_variable_get("@by").instance_variable_get("@key")
    end

  end
end