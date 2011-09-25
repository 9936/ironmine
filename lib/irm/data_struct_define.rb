module Irm::DataStructDefine
  class << self
    def map
      mapper = Mapper.new
      yield mapper
      @entities ||= {}
      @dependents ||= {}
      @entities.merge!(mapper.entities)
      merge_dependents(mapper.dependents)
    end

    def entities
      @entities||{}
    end

    def dependents
      @dependents||{}
    end

    private
    def merge_dependents(dependents)
      dependents.each do |entity_name,values|
        if @dependents[entity_name].present?
          @dependents[entity_name] +=values
        else
          @dependents[entity_name] = values
        end
      end
    end
  end

  class Mapper
    def initialize
      @entities = {}
      @dependents = {}
    end

    def entity(name,parent=nil,options={})
      entity = Entity.new(name,parent,options)
      yield entity
      @entities.merge!(name=>entity.entity)
    end

    def dependent(name,*args)
      @dependents.merge!(name=>args)
    end

    def entities
      @entities
    end

    def dependents
      @dependents
    end
  end

  class Entity
    def initialize(name,parent_entity=nil,options={})
      @entity=options.merge({:name=>name,
               :parent_entity=>parent_entity,
               :key_columns=>[],
               :columns=>{},
               :reference_columns=>[],
               :master_detail_columns=>[]})
    end

    def primary_key(name,type,options={})
      @entity[:columns].merge!({name.to_sym=>options.merge({:name=>name.to_sym,:type=>type})})
    end

    def key(name,type,options={})
      @entity[:columns].merge!({name.to_sym=>options.merge({:name=>name.to_sym,:type=>type})})
      @entity[:key_columns] << name.to_sym
    end

    def key_reference(name,type,ref_entity,options={})
      @entity[:columns].merge!({name.to_sym=>options.merge({:name=>name.to_sym,:type=>type,:ref_entity=>ref_entity})})
      @entity[:reference_columns] << name.to_sym
      @entity[:key_columns] << name.to_sym
    end

    def column(name,type,options={})
      @entity[:columns].merge!({name.to_sym=>options.merge({:name=>name.to_sym,:type=>type})})
    end

    def reference(name,type,ref_entity,options={})
      @entity[:columns].merge!({name.to_sym=>options.merge({:name=>name.to_sym,:type=>type,:ref_entity=>ref_entity})})
      @entity[:reference_columns] << name.to_sym
    end

    def master_detail(name,type,ref_entity,options={})
      @entity[:columns].merge!({name.to_sym=>options.merge({:name=>name.to_sym,:type=>type})})
      @entity[:master_detail_columns] << name.to_sym
    end

    def entity
      @entity
    end

    def name
      @entity[:name]
    end
  end

end