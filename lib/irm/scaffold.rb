module Irm::Scaffold
  def self.included(base)
    base.class_eval do
      class_option :module, :type => :string, :default => "",
                   :desc => "choose  modular"
      protected
      def file_path
        @file_path ||= (class_path + [file_name]).join('/')
        if @file_path
          @file_path
        else
          if options[:module].present?
            @file_path = (["modules",options[:module]]+class_path + [file_name]).join('/')
          else
            @file_path = (class_path + [file_name]).join('/')
          end
          @file_path
        end
      end
    end
  end
end