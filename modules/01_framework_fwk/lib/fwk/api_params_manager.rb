module Fwk::ApiParamsManager
  class << self
    def map
      @api_controlers ||= {}
      mapper = Mapper.new

      if block_given?
        yield mapper
      else
        mapper
      end

      new_api_controllers = mapper.mapped_api_controllers
      new_api_controllers.each do |controller, actions|
        if @api_controlers[controller].present? && @api_controlers[controller].any?
          @api_controlers[controller].merge!(actions)
        else
          @api_controlers[controller] = actions
        end
      end




    end

    def api_controllers
      @api_controlers
    end

  end

  class Mapper
    def initialize
      @api_controllers ||= {}
    end


    def controller(code, hash = {})
      if code.present? and hash.any?
        hash = hash.dup
        if @api_controllers[code].present? && @api_controllers[code].any?
          @api_controllers[code].merge!(hash)
        else
          @api_controllers[code] = hash
        end
      end
    end

    def mapped_api_controllers
      @api_controllers
    end

  end
end