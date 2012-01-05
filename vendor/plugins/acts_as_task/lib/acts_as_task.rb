module Ironmine
  module Acts
    module Task
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        # acts_as_searchable
        def acts_as_task(options = {})
          return if self.included_modules.include?(Ironmine::Acts::Task::InstanceMethods)

          Ironmine::Acts::Task::Helper.add_task_entry(self.name)

          default_options = {
                              :scope=>"as_task",
                              :show_url  => {:controller=>self.name.pluralize.underscore,:action=>"show",:id=>:id},
                              :title => :title,
                              :status_name=>:status_name,
                              :start_at=>:start_at,
                              :end_at=>:end_at
                             }
          # 多语言配置项
          cattr_accessor :task_options
          self.task_options = default_options.merge(options)
          send :include, Ironmine::Acts::Task::InstanceMethods

        end
      end

      module InstanceMethods
        def self.included(base)
          base.extend ClassMethods
        end


        def task_show_url_options
          url_options = task_options[:show_url].dup
          url_options.each do |key,value|
            url_options[key] = self.send(value) if value.is_a?(Symbol)&&self.respond_to?(value)
          end
          url_options
        end


        def task_attributes
          tmp_attributes = {:type=>self.class.name,:id=>self.id,:url_options=>self.task_show_url_options}
          if task_options[:title].present?&&self.respond_to?(task_options[:title].to_sym)
            tmp_attributes[:title]=   self.send(task_options[:title].to_sym)

          end
          if task_options[:status_name].present?&&self.respond_to?(task_options[:status_name].to_sym)
            tmp_attributes[:status_name]=   self.send(task_options[:status_name].to_sym)
          end
          if task_options[:start_at].present?&&self.respond_to?(task_options[:start_at].to_sym)
            tmp_attributes[:start_at]=   self.send(task_options[:start_at].to_sym)
          end
          if task_options[:end_at].present?&&self.respond_to?(task_options[:end_at].to_sym)
            tmp_attributes[:end_at]=   self.send(task_options[:end_at].to_sym)
          end
          tmp_attributes
        end


        module ClassMethods

        end
      end

      module Helper
        def self.add_task_entry(task_entry)
          #自动保存使用过acts_as_taks插件的ActiveRecord
          task_entries = Ironmine::STORAGE.get(:task_entries)||[]

          task_entries << task_entry
          task_entries.uniq!

          Ironmine::STORAGE.put(:task_entries,task_entries)

          puts self.task_entries
        end

        def self.task_entries
          Ironmine::STORAGE.get(:task_entries)||[]
        end
      end
    end
  end
end