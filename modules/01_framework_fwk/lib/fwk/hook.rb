module Fwk
  module Hook
    @@listener_classes = []
    @@listeners = nil
    @@hook_listeners = {}

    class << self
      # Adds a listener class.
      # Automatically called when a class inherits from Fwk::Hook::Listener.
      def add_listener(klass)
        raise "Hooks must include Singleton module." unless klass.included_modules.include?(Singleton)
        @@listener_classes << klass
        clear_listeners_instances
      end

      # Returns all the listerners instances.
      def listeners
        @@listeners ||= @@listener_classes.collect {|listener| listener.instance}
      end

      # Returns the listeners instances for the given hook.
      def hook_listeners(hook)
        @@hook_listeners[hook] ||= listeners.select {|listener| listener.respond_to?(hook)}
      end

      # Clears all the listeners.
      def clear_listeners
        @@listener_classes = []
        clear_listeners_instances
      end

      # Clears all the listeners instances.
      def clear_listeners_instances
        @@listeners = nil
        @@hook_listeners = {}
      end

      # Calls a hook.
      # Returns the listeners response.
      def call_hook(hook, context={})
        [].tap do |response|
          hls = hook_listeners(hook)
          if hls.any?
            hls.each {|listener| response << listener.send(hook, context)}
          end
        end
      end
    end

    # Base class for hook listeners.
    class Listener
      include Singleton

      # Registers the listener
      def self.inherited(child)
        Fwk::Hook.add_listener(child)
        super
      end

    end

    # Listener class used for views hooks.
    # Listeners that inherit this class will include various helpers by default.
    class ViewListener < Listener
      include ERB::Util
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::FormHelper
      include ActionView::Helpers::FormTagHelper
      include ActionView::Helpers::FormOptionsHelper
      include ActionView::Helpers::JavaScriptHelper
      include ActionView::Helpers::NumberHelper
      include ActionView::Helpers::UrlHelper
      include ActionView::Helpers::AssetTagHelper
      include ActionView::Helpers::TextHelper
      include Rails.application.routes.url_helpers
      include ApplicationHelper

      # Default to creating links using only the path.  Subclasses can
      # change this default as needed
      def self.default_url_options
        {:only_path => true }
      end

      # Helper method to directly render a partial using the context:
      #
      #   class MyHook < Fwk::Hook::ViewListener
      #     render_on :view_issues_show_details_bottom, :partial => "show_more_data"
      #   end
      #
      def self.render_on(hook, options={})
        define_method hook do |context|
          if context[:hook_caller].respond_to?(:render)
            context[:hook_caller].send(:render, {:locals => context}.merge(options))
          elsif context[:controller].is_a?(ActionController::Base)
            context[:controller].send(:render_to_string, {:locals => context}.merge(options))
          else
            raise "Cannot render #{self.name} hook from #{context[:hook_caller].class.name}"
          end
        end
      end

      def controller
        nil
      end

      def config
        ActionController::Base.config
      end
    end

    # Helper module included in ApplicationHelper and ActionController so that
    # hooks can be called in views like this:
    #
    #   <%= call_hook(:some_hook) %>
    #   <%= call_hook(:another_hook, :foo => 'bar') %>
    #
    # Or in controllers like:
    #   call_hook(:some_hook)
    #   call_hook(:another_hook, :foo => 'bar')
    #
    # Hooks added to views will be concatenated into a string. Hooks added to
    # controllers will return an array of results.
    #
    # Several objects are automatically added to the call context:
    #
    # * project => current project
    # * request => Request instance
    # * controller => current Controller instance
    # * hook_caller => object that called the hook
    #
    module Helper
      def call_hook(hook, context={})
        if is_a?(ActionController::Base)
          default_context = {:controller => self, :request => request, :hook_caller => self}
          Fwk::Hook.call_hook(hook, default_context.merge(context))
        else
          default_context = { :hook_caller => self }
          default_context[:controller] = controller if respond_to?(:controller)
          default_context[:request] = request if respond_to?(:request)
          Fwk::Hook.call_hook(hook, default_context.merge(context)).join(' ').html_safe
        end
      end
    end
  end
end

ApplicationHelper.send(:include, Fwk::Hook::Helper)
ActionController::Base.send(:include, Fwk::Hook::Helper)