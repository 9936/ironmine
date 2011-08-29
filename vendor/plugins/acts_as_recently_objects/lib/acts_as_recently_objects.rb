# ActsAsWatchable
module Ironmine
  module Acts
    module RecentlyObjects
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_recently_objects(options = {})
          return if self.included_modules.include?(Ironmine::Acts::RecentlyObjects::InstanceMethods)
          send :include, Ironmine::Acts::RecentlyObjects::InstanceMethods

          default_options = { :target_controller => "",
                              :target_action=> "show",
                              :target_id => "id",
                              :target_id_column => "id",
                              :target => "self",
                              :title => "",
                              :source_type => "self.class.name",
                              :source_id => "self.id"
                             }

          cattr_accessor :target_controller, :target_action, :target_id,
                         :show_title, :object_options, :g_source_type,
                         :g_source_id, :target, :target_id_column
          self.object_options = default_options.merge(options)

          self.target_controller = object_options[:target_controller]
          self.target_action = object_options[:target_action]
          self.target_id = object_options[:target_id]
          self.target_id_column = object_options[:target_id_column]
          self.show_title = object_options[:title]
          self.g_source_type = object_options[:source_type]
          self.g_source_id = object_options[:source_id]
          self.target = object_options[:target]

          class_eval do
            after_save :save_as_recently
            def self.current_accessible(companies=[])
              []
            end
          end

          send :include, Ironmine::Acts::RecentlyObjects::InstanceMethods
        end
      end

      module InstanceMethods
        def self.included(base)
          base.extend ClassMethods
        end

        def save_as_recently
          have_same, roc = have_same?
          if have_same
            ro = Irm::RecentlyObject.find(roc)
            ro.update_attribute(:updated_at, Time.now)
          else
            ro = Irm::RecentlyObject.new(:source_type => eval(self.g_source_type), :source_id => eval(self.g_source_id))
            ro.save
          end
        end

        def recently_object_name
          target = self
          self.target.split(".").each do |r|
            target = target.send(r.to_sym)
          end unless self.target == "self"
          target[self.show_title.to_sym]
        end

        def recently_object_url_options
          target = self
          self.target.split(".").each do |r|
            target = target.send(r.to_sym)
          end unless self.target == "self"
          {:controller => self.target_controller, :action => self.target_action, self.target_id_column.to_sym => target[self.target_id.to_sym]}
        end

        private
        def last_same?
          ro = Irm::RecentlyObject.order("updated_at DESC").first
          if ro
            r_source = eval(ro.source_type).find(ro.source_id)

            l_target = r_source
            r_target = self
            r_source.target.split(".").each do |l|
              l_target = l_target.send(l.to_sym)
            end unless r_source.target == "self"

            self.target.split(".").each do |r|
              r_target = r_target.send(r.to_sym)
            end unless self.target == "self"

            if(l_target.class.name == r_target.class.name && ( l_target[r_source.target_id.to_sym].to_s == (r_target[self.target_id.to_sym]).to_s))
              return true
            else
              return false
            end
          end
          false
        end

        def have_same?
          ros = Irm::RecentlyObject.where("1=1")
          ros.each do |ro|
            r_source = eval(ro.source_type).find(ro.source_id)

            l_target = eval(ro.source_type).find(ro.source_id)
            r_target = self

            r_source.target.split(".").each do |l|
              l_target = l_target.send(l.to_sym)
            end unless r_source.target == "self"

            self.target.split(".").each do |r|
              r_target = r_target.send(r.to_sym)
            end unless self.target == "self"

            if(l_target.class.name == r_target.class.name && ( l_target[r_source.target_id.to_sym].to_s == (r_target[self.target_id.to_sym]).to_s))
              return true, ro.id
            end
          end
          return false, "-1"
        end

        module ClassMethods

        end
      end
    end
  end
end