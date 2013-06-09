class Irm::ModelAssociationsController < ApplicationController
  layout "application_full"

  def index
    @group_models = Fwk::ModelAssociation.grouped_models
    #@group_models = {}
  end

  def get_data
    class_name = params[:class_name]
    result = {:class_name => class_name, :table_name => class_name.constantize.table_name, :has_many => [], :belongs_to => []}
    if class_name.present?
      begin
        associations = class_name.constantize.reflect_on_all_associations
        associations.each do |a|
          module_name = a.table_name.split("_").first.to_s.camelize

          if a.class_name.to_s.start_with?(module_name)
            model_class_name = a.class_name
          else
            model_class_name = "#{a.table_name.split("_").first.to_s.camelize}::#{a.class_name}"
          end
          child = {:name => a.name, :class_name => model_class_name, :table_name => a.table_name, :has_many => [], :belongs_to => [] }

          begin
            model_class_name.constantize.reflect_on_all_associations.each do |ca|
              if ca.macro.eql?(:belongs_to)
                child[:belongs_to] << {:name => ca.name}
              elsif ca.macro.eql?(:has_many)
                child[:has_many] << {:name => ca.name}
              end
            end
          end

          if a.macro.eql?(:belongs_to)
            result[:belongs_to] << child
          elsif a.macro.eql?(:has_many)
            result[:has_many] << child
          end



        end

      rescue
      end
    end
    render json: result.to_json
  end
end
