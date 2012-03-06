class Irm::BusinessObject < ActiveRecord::Base
  set_table_name :irm_business_objects

  has_many :object_attributes,:dependent => :destroy

  #多语言关系
  attr_accessor :name,:description
  has_many :business_objects_tls,:dependent => :destroy
  acts_as_multilingual

  validates_presence_of :business_object_code,:bo_table_name,:bo_model_name,:auto_generate_flag
  validates_uniqueness_of :business_object_code, :if => Proc.new { |i| !i.business_object_code.blank? }
  validates_uniqueness_of :bo_table_name,:scope => [:bo_model_name,:auto_generate_flag], :if => Proc.new { |i| !i.auto_generate_flag.eql?(Irm::Constant::SYS_YES) }
  validates_format_of :business_object_code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.business_object_code.blank?},:message=>:code
  validate :validate_database_info

  before_validation :before_validate_on_create,:on=>:create
  #加入activerecord的通用方法和scope
  query_extend


  scope :query_detail,lambda{|bo_id| where("EXISTS(SELECT 1 FROM #{Irm::ObjectAttribute.table_name} WHERE  #{Irm::ObjectAttribute.table_name}.business_object_id = #{table_name}.id AND #{Irm::ObjectAttribute.table_name}.relation_bo_id =? AND #{Irm::ObjectAttribute.table_name}.category = ?)",bo_id,"MASTER_DETAIL_RELATION")}


  # generate business object
  def generate_query(execute=false)
    query_str = {:select=>[],:joins=>[],:where=>[],:order=>[]}
    query_str[:select]<< "#{self.bo_table_name}.*"
    self.object_attributes.where("category in (?)",["LOOKUP_RELATION","MASTER_DETAIL_RELATION"]).each do |oa|
      join_object_attribute(query_str,oa)
    end

    generate_scope_str(query_str,execute)

  end
  # 根据传入的属性字段，生成查询SQL
  def generate_query_by_attributes(oas=[],execute=false,mini_column=false)
    return generate_query(execute) unless oas.any?

    query_str = {:select=>[],:joins=>[],:where=>[],:order=>[]}
    select_attributes = []
    join_attributes = []
    join_table_names = []
    self.object_attributes.each do |soa|
      # filter column or need to return column
      if((soa.filter_flag.eql?(Irm::Constant::SYS_YES)&&!mini_column)||oas.include?(soa.attribute_name.to_sym))
        select_attributes << soa
        join_table_names << soa.relation_table_alias if ["LOOKUP_RELATION","MASTER_DETAIL_RELATION"].include?(soa.category)
      end
    end

    self.object_attributes.each do |soa|
      if ["LOOKUP_RELATION","MASTER_DETAIL_RELATION"].include?(soa.category)&&join_table_names.include?(soa.relation_table_alias)
        join_attributes << soa
      end
    end if join_table_names.any?
    # mini column mode
    query_str[:select]<< "#{self.bo_table_name}.*" unless mini_column
    select_attributes.each do |sa|
      if mini_column&&sa.attribute_type.eql?("TABLE_COLUMN")
        query_str[:select] << %(#{self.bo_table_name}.#{sa.attribute_name})
      end
    end

    join_attributes.each do |ja|
      join_object_attribute(query_str,ja)
    end

    generate_scope_str(query_str,execute)

  end


  # For LOV 根据传入的属性字段（Hash），生成查询SQL
  def generate_query_by_hash_attributes(oas,execute = false)
    return generate_query(execute) unless oas.any?&&oas.is_a?(Hash)
    query_str = {:select=>[],:joins=>[],:where=>[],:order=>[]}
    select_attributes = []
    join_attributes = []
    join_table_names = []
    self.object_attributes.each do |soa|
      if(oas.keys.include?(soa.attribute_name))
        select_attributes << soa
        join_table_names << soa.relation_table_alias if ["LOOKUP_RELATION","MASTER_DETAIL_RELATION"].include?(soa.category)
      end
    end

    self.object_attributes.each do |soa|
      if soa.attribute_type.eql?("RELATION_COLUMN")&&join_table_names.include?(soa.relation_table_alias_name)&&soa.exists_relation_flag.eql?(Irm::Constant::SYS_NO)
        join_attributes << soa
      end
    end if join_table_names.any?

    select_attributes.each do |sa|
      if sa.attribute_type.eql?("TABLE_COLUMN")
        query_str[:select] << %(#{self.bo_table_name}.#{sa.attribute_name} #{oas[sa.attribute_name]})
      end
    end

    join_attributes.each do |ja|
      join_object_attribute(query_str,ja)
    end

    generate_scope_str(query_str,execute)

  end

  def approval_attributes
    self.object_attributes.multilingual.enabled.where(:approve_flag=>Irm::Constant::SYS_YES)
  end

  # 根据lov的值,取得lov的显示值
  def lookup_label_value(value,lov_value_field,params={})
    columns = Irm::SearchLayoutColumn.lookup_columns(self.id)
    label_attribute = Irm::ObjectAttribute.get_label_attribute(self.id)
    fields = [{:value_field=>true,:key=>lov_value_field.to_sym,:hidden=>true,:name=>lov_value_field,:data_type=>"varchar",:data_length=>"30"}]
    fields << {:label=>true,:key=>label_attribute[:attribute_name],:name=>label_attribute[:name],:data_type=>label_attribute[:data_type],:data_length=>label_attribute[:data_length]}
    if columns.any?
      columns.each do |column|
        next if column[:attribute_name].eql?(label_attribute[:attribute_name])
        if ["LOOKUP_RELATION","MASTER_DETAIL_RELATION"].include?(column[:category])
          fields << {:hidden=>true,:key=>column[:attribute_name],:name=>column[:name],:data_type=>column[:data_type],:data_length=>column[:data_length]}
          fields << {:key=>"#{column[:attribute_name]}_label",:name=>column[:name],:data_type=>column[:data_type],:data_length=>column[:data_length]}
        else
          fields << {:key=>column[:attribute_name],:name=>column[:name],:data_type=>column[:data_type],:data_length=>column[:data_length]}
        end
      end
    end

    current_record = eval(generate_query_by_attributes(fields.collect{|i| i[:key].to_sym},true,true)).where("#{self.bo_table_name}.#{lov_value_field} = ?",value)

    if self.bo_model_name.constantize.respond_to?(:lov)
      current_record = bo_model_name.constantize.send(:lov,current_record,params)
    end

    current_record = current_record.first

    if current_record
      return [current_record[lov_value_field],current_record[label_attribute.attribute_name.to_sym],current_record]
    else
      return ["","",{}]
    end
  end


  # 根据lov的显示值,取得lov的值
  def lookup_value(label_value,lov_value_field,params={})

    columns = Irm::SearchLayoutColumn.lookup_columns(self.id)
    label_attribute = Irm::ObjectAttribute.get_label_attribute(self.id)
    fields = [{:value_field=>true,:key=>lov_value_field.to_sym,:hidden=>true,:name=>lov_value_field,:data_type=>"varchar",:data_length=>"30"}]
    fields << {:label=>true,:key=>label_attribute[:attribute_name],:name=>label_attribute[:name],:data_type=>label_attribute[:data_type],:data_length=>label_attribute[:data_length]}
    if columns.any?
      columns.each do |column|
        next if column[:attribute_name].eql?(label_attribute[:attribute_name])
        if ["LOOKUP_RELATION","MASTER_DETAIL_RELATION"].include?(column[:category])
          fields << {:hidden=>true,:key=>column[:attribute_name],:name=>column[:name],:data_type=>column[:data_type],:data_length=>column[:data_length]}
          fields << {:key=>"#{column[:attribute_name]}_label",:name=>column[:name],:data_type=>column[:data_type],:data_length=>column[:data_length]}
        else
          fields << {:key=>column[:attribute_name],:name=>column[:name],:data_type=>column[:data_type],:data_length=>column[:data_length]}
        end
      end
    end

    current_record = eval(generate_query_by_attributes(fields.collect{|i| i[:key].to_sym},true,true)).where("#{self.bo_table_name}.#{label_attribute.attribute_name} like ?","%#{label_value}%")

    if self.bo_model_name.constantize.respond_to?(:lov)
      current_record = bo_model_name.constantize.send(:lov,current_record,params)
    end

    current_record = current_record.first

    if current_record.present?
      return [current_record[lov_value_field],current_record[label_attribute.attribute_name.to_sym],current_record]
    else
      return ["","",{}]
    end

  end

  def lookup(search,lov_value_field,params={})
    columns = Irm::SearchLayoutColumn.lookup_columns(self.id)
    label_attribute = Irm::ObjectAttribute.get_label_attribute(self.id)
    fields = [{:value_field=>true,:key=>lov_value_field.to_sym,:hidden=>true,:name=>lov_value_field,:data_type=>"varchar",:data_length=>"30"}]
    fields << {:label=>true,:key=>label_attribute[:attribute_name],:name=>label_attribute[:name],:data_type=>label_attribute[:data_type],:data_length=>label_attribute[:data_length]}
    if columns.any?
      columns.each do |column|
        next if column[:attribute_name].eql?(label_attribute[:attribute_name])
        if ["LOOKUP_RELATION","MASTER_DETAIL_RELATION"].include?(column[:category])
          fields << {:hidden=>true,:key=>column[:attribute_name],:name=>column[:name],:data_type=>column[:data_type],:data_length=>column[:data_length]}
          fields << {:key=>"#{column[:attribute_name]}_label",:name=>column[:name],:data_type=>column[:data_type],:data_length=>column[:data_length]}
        else
          fields << {:key=>column[:attribute_name],:name=>column[:name],:data_type=>column[:data_type],:data_length=>column[:data_length]}
        end
      end
    end

    datas = eval(generate_query_by_attributes(fields.collect{|i| i[:key].to_sym},true,true)).where("#{self.bo_table_name}.#{label_attribute.attribute_name} like ?","#{search}")

    if self.bo_model_name.constantize.respond_to?(:lov)
      datas = bo_model_name.constantize.send(:lov,datas,params)
    end

    datas = datas.limit(15)

    return [fields,datas]
  end


  def self.get_relation_bo_instance(relation_object_attribute,value)
    bo = self.query(relation_object_attribute.relation_bo_id).first
    relation_attribute = Irm::ObjectAttribute.query(relation_object_attribute.relation_object_attribute_id).first
    return  unless bo&&relation_attribute

    current_record = eval(bo.generate_query(true)).where("#{bo.bo_table_name}.#{relation_attribute.attribute_name} = ?",value).first

    return current_record
  end

  private
  def recursive_stringify_keys(hash)
    return unless hash.is_a?(Hash)
    hash.values.each do |v|
      next unless v.is_a?(Hash)
      recursive_stringify_keys(v)
    end
    hash.stringify_keys!
  end
  #process join attribute
  def join_object_attribute(query_str,join_attribute)
    if !join_attribute.relation_exists_flag.eql?(Irm::Constant::SYS_YES)
      relation_bo = self.class.query(join_attribute.relation_bo_id).first
      relation_attribute = Irm::ObjectAttribute.query(join_attribute.relation_object_attribute_id).first
      return unless relation_attribute&&relation_bo

      label_attribute = Irm::ObjectAttribute.get_label_attribute(join_attribute.relation_bo_id)
      query_str[:select]<<"#{join_attribute.relation_table_alias}.#{label_attribute.attribute_name} #{join_attribute.attribute_name}_label"

      where_clause_str = join_attribute.relation_where_clause||""

      # parse params in where clause
      if where_clause_str.strip.present?&&%r{\{\{.*\}\}}.match(join_attribute.where_clause)
        where_clause_template = Liquid::Template.parse join_attribute.where_clause
        where_clause_str = where_clause_template.render({"table"=>join_attribute.relation_table_alias,"master_table"=>self.bo_table_name})
      end
      where_clause_str.strip!

      if where_clause_str.present?
        where_clause_str = "#{self.bo_table_name}.#{join_attribute.attribute_name} = #{join_attribute.relation_table_alias}.#{relation_attribute.attribute_name} AND "+ where_clause_str
      else
        where_clause_str = "#{self.bo_table_name}.#{join_attribute.attribute_name} = #{join_attribute.relation_table_alias}.#{relation_attribute.attribute_name} "
      end

      # process multilingual
      if relation_bo.multilingual_flag.eql?(Irm::Constant::SYS_YES)
        where_clause_str << " AND "if(where_clause_str).length > 0
        if self.multilingual_flag.eql?(relation_bo.multilingual_flag)
          where_clause_str << " #{join_attribute.relation_table_alias}.language = #{self.bo_table_name}.language"
        else
          where_clause_str << " #{join_attribute.relation_table_alias}.language = '{{env.language}}'"
        end
      end
      if join_attribute.relation_type.eql?("LEFT_OUTER_JOIN")
        query_str[:joins] << "LEFT OUTER JOIN #{relation_bo.bo_table_name} #{join_attribute.relation_table_alias} ON  #{where_clause_str}"
      elsif join_attribute.relation_type.eql?("JOIN")
        query_str[:joins] << "JOIN #{relation_bo.bo_table_name} #{join_attribute.relation_table_alias} ON  #{where_clause_str}"
      else
        query_str[:joins] << "LEFT OUTER JOIN #{relation_bo.bo_table_name} #{join_attribute.relation_table_alias} ON  #{where_clause_str}"
      end

    end
  end
  # generate scope string by query hash
  def generate_scope_str(query_str,execute)
    # 取得对像model名称
    model_query = "#{self.bo_model_name}"

    # 如果为多语言对像，进行多语言过滤
    if self.multilingual_flag.eql?(Irm::Constant::SYS_YES)
      query_str[:where] << "#{self.bo_table_name}.language = '{{env.language}}'"
      model_query << %(.unscoped.current_opu("#{self.bo_table_name}").from("#{self.bo_table_name}"))
    end

    # select字段
    model_query << %(.select("#{query_str[:select].join(",")}"))
    query_str[:joins].each do |j|
      model_query << %(.joins("#{j}"))
    end
    query_str[:where].each do |w|
      model_query << %(.where("#{w}"))
    end
    # 如果是需要立即执行的查询，则需要按当前用户将参数替换掉
    if (execute&&%r{\{\{.*\}\}}.match(model_query))
      env = Irm::Person.env.dup
      recursive_stringify_keys(env)
      model_query_template = Liquid::Template.parse model_query
      model_query = model_query_template.render(env)
    end
    model_query
  end

  # 新建业务对像前,从数据库中取得相应的信息
  def before_validate_on_create
    if self.new_record?&&self.bo_model_name.present?&&defined?(self.bo_model_name.constantize)
      model = self.bo_model_name.constantize

      self.bo_table_name = model.table_name

      if self.class.connection.table_exists?(self.bo_table_name)
        self.business_object_code = self.bo_table_name.upcase
        self.standard_flag= Irm::Constant::SYS_YES

        if model.respond_to?(:multilingual)&&model.respond_to?(:view_name)
          self.bo_table_name = model.view_name
          self.multilingual_flag = Irm::Constant::SYS_YES
        elsif model.respond_to?(:multilingual_view_name)
          self.bo_table_name = model.multilingual_view_name
          self.multilingual_flag = Irm::Constant::SYS_YES
        elsif model.respond_to?(:view_name)
          self.bo_table_name = model.view_name
          self.multilingual_flag = Irm::Constant::SYS_NO
        end
      end
      self.business_object_code = self.bo_table_name.slice(self.bo_table_name.length-30> 0 ? self.bo_table_name.length-30 : 0  ,self.bo_table_name.length).upcase
      self.business_object_code = business_object_code.slice(1,business_object_code.length) if business_object_code[0].eql?("_")
    end
  end

  def validate_database_info
    unless self.bo_table_name.present?
      self.errors.add(:bo_model_name,I18n.t(:label_irm_business_object_error_table_not_exists))
    end
  end


  # 取得业务对像实例中某个属性的值
  def self.attribute_of(bo,attribute_name,business_object_attribute=nil)
    value = nil

    # 如果业务对像属性是关联类,需要使用lable字段代替
    if business_object_attribute&&["LOOKUP_RELATION","MASTER_DETAIL_RELATION"].include?(business_object_attribute.category)
      value = bo.attributes["#{attribute_name}_label"]
    end

    if !value.present?&&bo.respond_to?(attribute_name.to_sym)
      value = bo.send(attribute_name.to_sym)
    end

    unless value
      value = bo.attributes[attribute_name]
    end
    value
  end

  # 将业务对像转化为liquid 参数
  def self.liquid_attributes(bo_instance,recursive=false)
    bo = Irm::BusinessObject.where(:bo_model_name=>bo_instance.class.name).first
    return {} unless bo
    origin_attributes = self.attributes_to_hash(bo_instance)
    result_attributes = {bo.business_object_code.downcase=>origin_attributes}
    if recursive
      origin_attributes.values.each do |attr|
        if attr.is_a?(ActiveRecord::Base)
          attr_bo = Irm::BusinessObject.where(:bo_model_name=>attr.class.name).first
          result_attributes.merge!({attr_bo.business_object_code.downcase=>self.attributes_to_hash(attr)})
        end
      end
    end
    return result_attributes
  end


  def self.attributes_to_hash(bo_instance)
    bo_attributes = Irm::ObjectAttribute.query_by_model_name(bo_instance.class.name)
    attributes_hash = {}
    bo_attributes.each do |boa|
      # master detail
      if "MASTER_DETAIL_RELATION".eql?(boa.category)
        value = get_relation_bo_instance(boa,self.attribute_of(bo_instance,boa.attribute_name))
      else
        value = self.attribute_of(bo_instance,boa.attribute_name,boa)
      end
      attributes_hash.merge!(boa.attribute_name.to_sym=>value)
    end
    return attributes_hash
  end

  def self.mail_message_id(bo_instance,identity="bo")
    timestamp = bo_instance.send(bo_instance.respond_to?(:created_at) ? :created_at : :updated_at)
    hash = "ironmine.#{identity}.#{bo_instance.class.name.underscore}.#{bo_instance.id}.#{timestamp.strftime("%Y%m%d%H%M%S")}"
    host = Irm::MailManager.default_email_from.to_s.gsub(%r{^.*@}, '')
    "<#{hash}@#{host}>"
  end

  def self.class_name_to_code(class_name)
    class_name.underscore.gsub("\/","__").upcase
  end

  def self.code_to_class_name(code)
    code.downcase.gsub("__","\/").camelize
  end

  def self.class_name_to_meaning(class_name)
    I18n.t("label_"+class_name.underscore.gsub("/","_"))
  end

end
