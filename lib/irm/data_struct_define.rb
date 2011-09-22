module Irm::DataStructDefine
  class << self
    def map
      mapper = Mapper.new
      yield mapper
      @entities ||= {}
      @entities.merge(mapper.entities)
    end

    def entities
      @entities
    end

  end

  class Mapper
    def initialize
      @entities={}
    end

    def entity(name,options={},&blk)

    end

    def entities
      @entities
    end
  end

  class Entity
    def initialize
      @entity={:parent_entity=>nil,
               :key_columns=>[],
               :columns=>{},
               :reference_columns=>[],
               :master_detail_columns=>[]}
    end

    def key(name,type,options={})
      @entity[:columns].merge!({name=>options.merge({:name=>name,:type=>type})})
      @entity[:key_columns] << name
    end

    def column(name,type,options={})
      @entity[:columns].merge!({name=>options.merge({:name=>name,:type=>type})})
    end

    def reference(name,type,ref_entity,options={})
      @entity[:columns].merge!({name=>options.merge({:name=>name,:type=>type})})
      @entity[:reference_columns] << name
    end

    def master_detail(name,type,ref_entity,options={})
      @entity[:columns].merge!({name=>options.merge({:name=>name,:type=>type})})
      @entity[:master_detail_columns] << name
    end

    def entity
      @entity
    end
  end

end