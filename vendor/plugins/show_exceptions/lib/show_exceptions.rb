module ShowExceptions
  CUSTOM_RESCUES_TEMPLATE_PATH = File.join(File.dirname(__FILE__),"..", 'templates')
  def self.included(base)
    base.class_eval do

      private
        def render_exception(env, exception)
          log_error(exception)
          exception = original_exception(exception)

          request = ActionDispatch::Request.new(env)
          if @consider_all_requests_local || request.local?
            rescue_action_locally(request, exception)
          else
            rescue_custom_action_locally(request, exception)
          end
        rescue Exception => failsafe_error
          $stderr.puts "Error during failsafe response: #{failsafe_error}\n  #{failsafe_error.backtrace * "\n  "}"
          FAILSAFE_RESPONSE
        end


        # Render detailed diagnostics for unhandled exceptions rescued from
        # a controller action.
        def rescue_custom_action_locally(request, exception)
          template = ActionView::Base.new([CUSTOM_RESCUES_TEMPLATE_PATH],
            :request => request,
            :exception => exception,
            :application_trace => application_trace(exception),
            :framework_trace => framework_trace(exception),
            :full_trace => full_trace(exception),
            :status_code => status_code(exception)
          )
          file = "rescues/#{@@rescue_templates[exception.class.name]}.erb"
          body = template.render(:file => file, :layout => 'rescues/layout.erb')
          render(status_code(exception), body)
        end

    end
  end
end