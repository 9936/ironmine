module Irm::DataStructDefine
  class << self
    def map(&blk)
      mapper = Mapper.new
      mapper.instance_eval(&blk)
      @entries ||= {}
      @entries.merge(mapper.entries)
    end

    def functions
      @functions
    end

    # Returns the permission of given name or nil if it wasn't found
    # Argument should be a symbol
    def function(name)
      functions[name.to_sym]
    end

    # Returns the actions that are allowed by the permission of given name
    def allowed_actions(permission_name)
      perm = permission(permission_name)
      perm ? perm.actions : []
    end

    def public_permissions
      @public_permissions ||= @permissions.select {|p| p.public?}
    end

    def members_only_permissions
      @members_only_permissions ||= @permissions.select {|p| p.require_member?}
    end

    def loggedin_only_permissions
      @loggedin_only_permissions ||= @permissions.select {|p| p.require_loggedin?}
    end

    def available_project_modules
      @available_project_modules ||= @permissions.collect(&:project_module).uniq.compact
    end

    def modules_permissions(modules)
      @permissions.select {|p| p.project_module.nil? || modules.include?(p.project_module.to_s)}
    end
  end

  class Mapper
    def initialize
    end

    def function(name, hash, options={})
      @functions ||= {}
      if @functions.keys.include?(name.to_sym)
        exists_permissions  = @functions[name.to_sym][:permissions]
        permissions = hash.dup
        exists_permissions.each do |controller,actions|
          if(hash[controller])
            exists_permissions[controller] += hash[controller]
            exists_permissions[controller].uniq!
            permissions.delete(controller)
          end
        end
        exists_permissions.merge!(permissions)
      else
        @functions.merge!({name.to_sym=>{:permissions=>hash,:options=>options}})
      end
    end

    def mapped_functions
      @functions
    end
  end

end