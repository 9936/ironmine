class Irm::ObjectAttribute < ActiveRecord::Base
  set_table_name :irm_object_attributes

  before_validation :check_attribute

  belongs_to :business_object

  attr_accessor :step
  #多语言关系
  attr_accessor :name,:description
  has_many :object_attributes_tls,:dependent => :destroy
  before_create :build_sequence

  after_save :fix_required_value


  acts_as_multilingual({:required=>[]})

  #删除关联字段的同时,删除别名字段
  #has_many :object_attributes,:foreign_key => :relation_alias_ref_id,:dependent => :destroy

  has_many :search_layout_columns ,:dependent => :destroy

  has_many :report_type_fields,:dependent => :destroy

  #  验证基础字段
  validates_presence_of :attribute_name,:if=>Proc.new{|i| i.check_step(2)}

  validates_presence_of :business_object_id,:attribute_type,:field_type,:if=>Proc.new{|i| i.check_step(1)}

  validates_presence_of :category,:if=>Proc.new{|i| i.check_step(1)&&i.attribute_type.present?&&i.attribute_type.eql?("TABLE_COLUMN")}

  validates_presence_of :name,:if => Proc.new { |i|i.name=i.attributes[:name]  if i.attributes[:name];i.check_step(2)&&!not_auto_mult}

  validates_presence_of :required_default_value, :if => Proc.new {|i| i.required_flag.eql?('Y')}

  # 验证属性名称的唯一性
  validates_uniqueness_of :attribute_name,:scope=>[:opu_id,:business_object_id,:external_system_id],:if => Proc.new { |i| i.attribute_name.present?&&i.business_object_id.present? }
  validates_format_of :attribute_name, :with => /^[a-z]+[a-z0-9_]*$/ ,:if=>Proc.new{|i| i.attribute_name.present?},:message=>:label_irm_object_attribute_attribute_name_format

  # 当属性为表格属性时,从数据库读取表格列信息
  validate :validate_table_column,:if=> Proc.new{|i| i.attribute_name.present?&&i.attribute_type.present?&&i.attribute_type.eql?("TABLE_COLUMN")}

  # 验证关联关系
  validates_presence_of :relation_bo_id,:relation_object_attribute_id,:if=> Proc.new{|i| i.category.present?&&["LOOKUP_RELATION","MASTER_DETAIL_RELATION"].include?(i.category)&&i.check_step(2)}
  validates_format_of :relation_table_alias, :with => /^[A-Za-z0-9_]*$/ ,:if=>Proc.new{|i| i.relation_table_alias.present?},:message=>:code

  # 设置关联关系表别名
  before_save :prepare_relation_table_alias

  # validate lookup master detail table name alias
  validate :validate_model_attribute,:if=> Proc.new{|i| i.attribute_type.present?&&i.attribute_name.present?&&i.attribute_type.eql?("MODEL_ATTRIBUTE")}

  validates_presence_of :pick_list_options,:if => Proc.new{|i| ["GLOBAL_CUX_FIELD","SYSTEM_CUX_FIELD"].include?(i.field_type)&&["PICK_LIST","PICK_LIST_MULTI"].include?(i.category)&&i.check_step(2)}

  validate :validate_pick_list,:if => Proc.new{|i| i.pick_list_options.present?&&i.data_default_value.present?&&["GLOBAL_CUX_FIELD","SYSTEM_CUX_FIELD"].include?(i.field_type)&&["PICK_LIST","PICK_LIST_MULTI"].include?(i.category)}

  #加入activerecord的通用方法和scope
  query_extend

  # 设置名称字段,一个对像中只有一个名称字段
  after_save :clear_other_label_flag

  scope :order_by_sequence, order("#{table_name}.required_flag DESC, #{table_name}.display_sequence ASC")

  scope :with_relation_bo,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::BusinessObject.view_name} relation_bo ON relation_bo.id = #{table_name}.relation_bo_id and relation_bo.language='#{language}'").
    joins("LEFT OUTER JOIN #{self.view_name} relation_bo_attribute ON relation_bo_attribute.id = #{table_name}.relation_object_attribute_id and relation_bo_attribute.language='#{language}'").
    select("relation_bo.name relation_bo_name,relation_bo.bo_table_name relation_bo_table_name,relation_bo_attribute.name relation_bo_attribute_name ,relation_bo_attribute.attribute_name relation_attribute_name")
  }
  scope :with_lov,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::ListOfValue.view_name} lov ON lov.lov_code = #{table_name}.lov_code and lov.language='#{language}'").
    select("lov.name lov_name")
  }

  scope :query_by_business_object_code,lambda{|business_object_code|
    joins("JOIN #{Irm::BusinessObject.table_name} ON #{Irm::BusinessObject.table_name}.id = #{table_name}.business_object_id AND #{Irm::BusinessObject.table_name}.business_object_code = '#{business_object_code}'").
        select("#{Irm::BusinessObject.table_name}.business_object_code").select_all
  }

  scope :query_by_business_object,lambda{|business_object_id|
    where(:business_object_id=>business_object_id)
  }

  scope :with_attribute_type,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} attribute_type ON attribute_type.lookup_type='BO_ATTRIBUTE_TYPE' AND attribute_type.lookup_code = #{table_name}.attribute_type AND attribute_type.language= '#{language}'").
    select(" attribute_type.meaning attribute_type_name")
  }

  scope :with_field_type,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} field_type ON field_type.lookup_type='BO_ATTRIBUTE_FIELD_TYPE' AND field_type.lookup_code = #{table_name}.field_type AND field_type.language= '#{language}'").
    select(" field_type.meaning field_type_name")
  }

  scope :with_category,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} category ON category.lookup_type='BO_ATTRIBUTE_CATEGORY' AND category.lookup_code = #{table_name}.category AND category.language= '#{language}'").
    select(" category.meaning category_name")
  }
  scope :with_relation_type,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} relation_type ON relation_type.lookup_type='BO_ATTRIBUTE_RELATION_TYPE' AND relation_type.lookup_code = #{table_name}.relation_type AND relation_type.language= '#{language}'").
    select(" relation_type.meaning relation_type_name")
  }

  scope :table_column,lambda{
    where(:attribute_type=>"TABLE_COLUMN")
  }

  scope :without_external_system, lambda{|system_id|
    where("NOT EXISTS(SELECT * FROM #{Irm::ObjectAttributeSystem.table_name} oas WHERE oas.external_system_id = ? AND oas.object_attribute_id = #{table_name}.id)", system_id)
  }

  scope :custom_field_with_system, lambda{|system_id|
    where("(#{Irm::ObjectAttribute.table_name}.field_type = ? AND #{Irm::ObjectAttribute.table_name}.status_code = ?) OR (#{Irm::ObjectAttribute.table_name}.field_type = ? AND #{Irm::ObjectAttribute.table_name}.external_system_id=?)", "GLOBAL_CUX_FIELD", "ENABLED", "SYSTEM_CUX_FIELD", system_id).
        order("system_flag ASC").
        select("IF(#{Irm::ObjectAttribute.table_name}.external_system_id is NULL, 'N', 'Y') system_flag")
  }

  scope :with_external_system, lambda{|system_id|
    joins("JOIN #{Irm::ObjectAttributeSystem.table_name} ON #{Irm::ObjectAttributeSystem.table_name}.object_attribute_id = #{table_name}.id").
        where("#{Irm::ObjectAttributeSystem.table_name}.external_system_id = ?", system_id).
        select("#{Irm::ObjectAttributeSystem.table_name}.id global_flag")
  }


  scope :selectable_column,lambda{
    where("#{table_name}.attribute_type='TABLE_COLUMN'")
  }

  scope :person_column,lambda{
    where("#{table_name}.person_flag=?",Irm::Constant::SYS_YES)
  }

  scope :updateable_column,lambda{
    where("#{table_name}.update_flag=?",Irm::Constant::SYS_YES)
  }

  scope :filterable,lambda{ |cux_flag|
    if cux_flag
      where("#{table_name}.filter_flag=? OR #{table_name}.field_type=?",Irm::Constant::SYS_YES,'GLOBAL_CUX_FIELD')
    else
      where(:filter_flag=>Irm::Constant::SYS_YES)
    end
  }

  scope :query_by_model_name,lambda{|model_name|
    joins("JOIN #{Irm::BusinessObject.table_name} ON #{Irm::BusinessObject.table_name}.id = #{table_name}.business_object_id").
    where("#{Irm::BusinessObject.table_name}.bo_model_name = ?",model_name)
  }

  scope :standard_field,lambda{
    where("#{table_name}.field_type != ? ",'CUSTOMED_FIELD')
  }

  scope :custom_field,lambda{
    where("#{table_name}.field_type = ? ",'CUSTOMED_FIELD')
  }

  scope :real_field,lambda{
    where("#{table_name}.attribute_type in (?)",["TABLE_COLUMN","MODEL_ATTRIBUTE"])
  }

  def self.list_all
    self.select_all.
        with_relation_bo(I18n.locale).
        with_attribute_type(I18n.locale).
        with_field_type(I18n.locale).
        with_category(I18n.locale).
        with_relation_type(I18n.locale)
  end

  def check_step(stp)
    self.step.nil?||self.step.to_i>=stp
  end


  def select_table_name
    self.business_object.bo_table_name
  end

  def self.get_ref_bo_table_name(bo_id,attribute_name)
    object_attribute = self.where(:business_object_id=>bo_id,:attribute_name=>attribute_name).first
    if object_attribute.present?&&["LOOKUP_RELATION","MASTER_DETAIL_RELATION"].include?(object_attribute.category)
      return object_attribute.relation_table_alias
    end
  end

  # 取得业务对像label字段
  def self.get_label_attribute(business_object_id)
    label_attribute = self.multilingual.where(:label_flag=>Irm::Constant::SYS_YES,:business_object_id=>business_object_id).first
    if label_attribute
      return label_attribute
    else
      return self.multilingual.where(:attribute_name=>"id",:business_object_id=>business_object_id).first||self.where(:business_object_id=>business_object_id).first
    end
  end

  private
  def check_attribute
    if Irm::Constant::SYS_YES.eql?(self.label_flag)
      self.field_type="STANDARD_FIELD"
    end
    case self.attribute_type
      when "TABLE_COLUMN"
        unless self.category.present?&&["LOOKUP_RELATION","MASTER_DETAIL_RELATION"].include?(self.category)
          clean_column([:relation_exists_flag,:relation_bo_id,:relation_table_alias,:relation_column,:relation_object_attribute_id,:relation_type,:relation_where_clause])
        end
      when "MODEL_ATTRIBUTE"
        clean_column([:category,:relation_exists_flag,:relation_bo_id,:relation_table_alias,:relation_column,:relation_object_attribute_id,:relation_type,:relation_where_clause,:lov_code,:data_type,:data_length,:data_null_flag,:data_key_type,:data_default_value,:data_extra_info])
    end
  end

  def clean_column(attributes=[])
    attributes.each do |a|
      self.send((a.to_s+"="),nil) if self.respond_to?((a.to_s+"="))
    end
  end

  def fix_required_value
    if self.required_flag.eql?("Y") and self.required_default_value.present?
      bo = Irm::BusinessObject.find(self.business_object_id)
      if bo.present?
        if self.external_system_id.present?
          bo.bo_model_name.constantize.update_all("#{bo.bo_model_name.constantize.table_name}.#{self.attribute_name} = '#{self.required_default_value}'",
                                                  "#{bo.bo_model_name.constantize.table_name}.external_system_id = '#{self.external_system_id}' AND (#{bo.bo_model_name.constantize.table_name}.#{self.attribute_name} is NULL OR #{bo.bo_model_name.constantize.table_name}.#{self.attribute_name} = '')")
        else
          bo.bo_model_name.constantize.update_all("#{bo.bo_model_name.constantize.table_name}.#{self.attribute_name} = '#{self.required_default_value}'",
                                                  "(#{bo.bo_model_name.constantize.table_name}.#{self.attribute_name} is NULL OR #{bo.bo_model_name.constantize.table_name}.#{self.attribute_name} = '')")
        end
      end
    end
  end

  def prepare_relation_table_alias
    if self.relation_bo_id.present?&&self.category.present?&& ["LOOKUP_RELATION","MASTER_DETAIL_RELATION"].include?(self.category)
      look_for_name = true
      relation = Irm::BusinessObject.find(self.relation_bo_id)

      # 如果没有更改关联的model,无需重新计算表别名
      if self.relation_table_alias.present?&&self.relation_table_alias.start_with?(relation.bo_table_name)
        return
      end
      count = 0
      while look_for_name
         tmp_table = relation.bo_table_name
         unless count == 0
           tmp_table = "#{tmp_table}_#{(count+96).chr}"
         end
         count_scope = self.class.where(:business_object_id=>self.business_object_id,:relation_bo_id=>self.relation_bo_id,:relation_table_alias=>tmp_table)

         if self.id.present?
           count_scope = count_scope.where("id != ?",self.id)
         end

         if !self.business_object.bo_table_name.eql?(tmp_table)&&count_scope.count < 1
           look_for_name = false
           self.relation_table_alias = tmp_table
         end
         count = count + 1
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

  def validate_table_column
    column = nil
    tcs = self.class.connection.execute("DESCRIBE  #{self.business_object.bo_table_name}")
    tcs.each do |tc|
      if tc[0].eql?(self.attribute_name)
        column = tc
      end
    end
    if column
      data_type_length = column[1].split("(")
      self.data_type = data_type_length[0]
      self.data_length = nil
      self.data_length = data_type_length[1].gsub(/\)/,"") if data_type_length[1]
      self.data_null_flag = ("NO".eql?(column[2]) ? Irm::Constant::SYS_NO : Irm::Constant::SYS_YES)
      self.data_key_type = column[3]
      unless column[0].start_with?("attribute")|| column[0].start_with?("sattribute")
        self.data_default_value = column[4]
      end

      self.data_extra_info = column[5]
    else
      errors.add(:attribute_name,I18n.t(:label_irm_object_attribute_invalid_table_attribute))
    end
  end


  def validate_pick_list
    unless pick_options.include?(self.data_default_value)
      errors.add(:data_default_value,I18n.t(:label_irm_object_attribute_pick_list_default_value_error))
    end
  end

  def pick_options
    (self.pick_list_options||"").split("\r\n")
  end

  def clear_other_label_flag
    if Irm::Constant::SYS_YES.eql?(self.label_flag)
      self.class.where("business_object_id = ? AND label_flag = ? AND id != ?", self.business_object_id,Irm::Constant::SYS_YES,self.id).update_all(:label_flag=>Irm::Constant::SYS_NO)
    end
  end

  private
  #构建sequence
  def build_sequence
    current_sequence = Irm::ObjectAttribute.select("display_sequence").where(:business_object_id => self.business_object_id, :field_type => "GLOBAL_CUX_FIELD").order("display_sequence DESC").first
    if current_sequence.present?
      self.display_sequence = current_sequence[:display_sequence] + 1
    else
      self.display_sequence = 1
    end
  end

end
