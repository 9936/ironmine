module Fwk
  class ModelAssociation
    class << self
      def grouped_models
        return @group_models  if @group_models.present? && @group_models.any?

        begin
          rails_config = Rails.application.config
          rails_config.fwk.modules.each do |module_name|
            Dir["#{Rails.root}/#{rails_config.fwk.module_folder}/#{rails_config.fwk.module_mapping[module_name]}/app/models/#{module_name}/*.rb"].each do |file|
              begin
                require file
              rescue
              end
            end
          end
        end

        @group_models = {}
        ActiveRecord::Base.subclasses.each do |type|
          module_and_class = type.name.split("::")
          module_name =  module_and_class.first.downcase
          next if module_name.eql?("delayed") || module_name.eql?("activerecord")
          @group_models[module_name.to_sym] ||= []
          @group_models[module_name.to_sym] << module_and_class.last
          #model = type.name.constantize
        end
        @group_models
      end
    end
  end
end