class Irm::ObjectAttribute < ActiveRecord::Base
  set_table_name :irm_object_attributes

  before_validation :check_attribute

  belongs_to :business_object,:foreign_key=>:business_object_code,:primary_key=>:business_object_code

  attr_accessor :step
  #多语言关系
  attr_accessor :name,:description
  has_many :object_attributes_tls,:dependent => :destroy
  acts_as_multilingual

  validates_presence_of :business_object_code,:attribute_name,:approval_page_field_flag
  validates_uniqueness_of :attribute_name, :scope=>:business_object_code,:if => Proc.new { |i| !i.attribute_name.blank?&&!i.business_object_code.blank? }
  validates_presence_of :exists_relation_flag,:relation_bo_code,:relation_table_alias_name,:relation_column,:if => Proc.new { |i| !i.attribute_type.blank?&&["RELATION_COLUMN","LOOKUP_COLUMN","MASTER_DETAIL_COLUMN"].include?(i.attribute_type)}
  validates_presence_of :where_clause,:if => Proc.new { |i| !i.attribute_type.blank?&&i.attribute_type.eql?("RELATION_COLUMN")&&i.exists_relation_flag.eql?(Irm::Constant::SYS_NO) }
  validates_format_of :relation_table_alias_name, :with => /^[A-Za-z0-9_]*$/ ,:if=>Proc.new{|i| i.relation_table_alias_name.present?}
  validate :validate_relation,:if=> Proc.new{|i| i.relation_table_alias_name.present?&&!self.relation_bo_code.blank?&&!i.attribute_type.blank?&&i.attribute_type.eql?("RELATION_COLUMN")}
  # validate lookup master detail table name alias
  validate :validate_lookup_master_detail,:if=> Proc.new{|i| !self.relation_bo_code.blank?&&!i.attribute_type.blank?&&["LOOKUP_COLUMN","MASTER_DETAIL_COLUMN"].include?(i.attribute_type)}
  validate :validate_model_attribute,:if=> Proc.new{|i| !i.attribute_type.blank?&&i.attribute_type.eql?("MODEL_ATTRIBUTE")}
  #加入activerecord的通用方法和scope
  query_extend

  scope :with_relation_bo,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::BusinessObject.view_name} relation_bo ON relation_bo.business_object_code = #{table_name}.relation_bo_code and relation_bo.language='#{language}'").
    select("relation_bo.name relation_bo_name")
  }
  scope :with_lov,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::ListOfValue.view_name} lov ON lov.lov_code = #{table_name}.lov_code and lov.language='#{language}'").
    select("lov.name lov_name")
  }

  scope :query_by_business_object_code,lambda{|business_object_code|
    where(:business_object_code=>business_object_code)
  }

  scope :with_attribute_type,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} attribute_type ON attribute_type.lookup_type='BO_ATTRIBUTE_TYPE' AND attribute_type.lookup_code = #{table_name}.attribute_type AND attribute_type.language= '#{language}'").
    select(" attribute_type.meaning attribute_type_name")
  }

  scope :with_field_type,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} field_type ON field_type.lookup_type='BO_ATTRIBUTE_FIELD_TYPE' AND field_type.lookup_code = #{table_name}.field_type AND field_type.language= '#{language}'").
    select(" field_type.meaning field_type_name")
  }

  scope :table_column,lambda{
    where(:attribute_type=>"TABLE_COLUMN")
  }


  scope :selectable_column,lambda{
    where("#{table_name}.attribute_type='TABLE_COLUMN' OR #{table_name}.attribute_type = 'RELATION_COLUMN'")
  }

  scope :person_column,lambda{
    where("#{table_name}.person_flag=?",Irm::Constant::SYS_YES)
  }

  scope :updateable_column,lambda{
    where("#{table_name}.update_flag=?",Irm::Constant::SYS_YES)
  }

  scope :filterable,lambda{
    where(:filter_flag=>Irm::Constant::SYS_YES)
  }

  scope :query_by_model_name,lambda{|model_name|
    joins("JOIN #{Irm::BusinessObject.table_name} ON #{Irm::BusinessObject.table_name}.business_object_code = #{table_name}.business_object_code").
    where("#{Irm::BusinessObject.table_name}.bo_model_name = ?",model_name)
  }

  scope :standard_field,lambda{
    where("#{table_name}.field_type != ? ",'CUSTOMED_FIELD')
  }

  scope :custom_field,lambda{
    where("#{table_name}.field_type = ? ",'CUSTOMED_FIELD')
  }

  scope :with_business_object_id,lambda{
    joins("JOIN #{Irm::BusinessObject.table_name} ON #{Irm::BusinessObject.table_name}.business_object_code = #{table_name}.business_object_code").
    select("#{Irm::BusinessObject.table_name}.id business_object_id")
  }


  def select_table_name
    t_name = ""
    case self.attribute_type
      when "TABLE_COLUMN"
        t_name = self.business_object.bo_table_name
      when "RELATION_COLUMN"
        t_name = self.relation_table_alias_name
    end
    t_name
  end


  private
  def check_attribute
    case self.attribute_type
      when "TABLE_COLUMN"
        clean_column([:relation_bo_code,:relation_table_alias_name,:relation_column,:where_clause])
      when "MODEL_ATTRIBUTE"
        clean_column([:relation_bo_code,:relation_table_alias_name,:relation_column,:where_clause])
        self.field_type= "CUSTOMED_FIELD"
      when "RELATION_COLUMN"
        relation_attribute = self.class.where(:business_object_code=>self.relation_bo_code,:attribute_name=>self.relation_column).first
        self.data_length = relation_attribute.data_length
        self.data_type = relation_attribute.data_type
        self.field_type= "CUSTOMED_FIELD"

    end
  end

  def clean_column(attributes=[])
    attributes.each do |a|
      self.send((a.to_s+"="),nil) if self.respond_to?((a.to_s+"="))
    end
  end

  def validate_lookup_master_detail
    attributes = self.class.where(:business_object_code=>self.business_object_code,:relation_table_alias_name=>self.relation_table_alias_name).where("#{self.class.table_name}.exists_relation_flag IS NULL OR #{self.class.table_name}.exists_relation_flag=?",Irm::Constant::SYS_NO)
    if self.id
      attributes = attributes.where("#{self.class.table_name}.id !=?",self.id)
    end
    if attributes.size>0
      errors.add(:relation_table_alias_name,I18n.t("activerecord.errors.messages.taken"))
    end
  end


  def validate_relation
    if self.exists_relation_flag.eql?(Irm::Constant::SYS_YES)
      attributes = self.class.where(:business_object_code=>self.business_object_code,:relation_bo_code=>self.relation_bo_code).where("#{self.class.table_name}.where_clause IS NOT NULL")
      attribute = attributes.detect{|oa| oa.relation_table_alias_name.eql?(self.relation_table_alias_name)}
      errors.add(:relation_table_alias_name,I18n.t(:label_irm_object_attribute_invalid_exists_relation_table)+":#{attributes.collect{|oa| oa.relation_table_alias_name}.join(",")}") if attribute.nil?
    else
      attributes = self.class.where(:business_object_code=>self.business_object_code,:relation_table_alias_name=>self.relation_table_alias_name).where("#{self.class.table_name}.exists_relation_flag IS NULL OR #{self.class.table_name}.exists_relation_flag=?",Irm::Constant::SYS_NO)
      if self.id
        attributes = attributes.where("#{self.class.table_name}.id !=?",self.id)
      end
      if attributes.size>0
        errors.add(:relation_table_alias_name,I18n.t("activerecord.errors.messages.taken"))
      end
    end
  end

  def validate_model_attribute
    if self.business_object&&self.business_object.bo_model_name
      pass = true
      begin
        method = self.business_object.bo_model_name.constantize.new.public_method(self.attribute_name)
        if method
          pass = !method.parameters.detect{|p| p[0].eql?(:req)}.present?
        else
          pass = false
        end
      rescue => text
        pass = false
      end
    end
    errors.add(:attribute_name,I18n.t(:label_irm_object_attribute_invalid_model_attribute)) unless pass
  end

end
