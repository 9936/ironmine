class Irm::ReportCriterion < ActiveRecord::Base
  set_table_name :irm_report_criterions

  belongs_to :report
  belongs_to :report_type_field,:foreign_key => :field_id

  OPERATORS = {:common=>['E','N','L','G','M','H','NIL','NNIL'],
             :varchar=>['BW','EW','U','X'],
             :text=>['BW','EW','U','X'],
             :datetime=>['IN'],
             :int=>[]
            }.freeze


  validates_presence_of :operator_code, :if => Proc.new { |i| i.field_id.present? }
  validates_presence_of :filter_value, :if => Proc.new { |i| i.field_id.present?&&i.operator_code.present?&&!["NIL","NNIL"].include?(i.operator_code) }
  validate :validate_data_type_filter_value, :if => Proc.new { |i| !i.field_id.blank? }

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  def ref_object_attribute
    @object_attribute ||= Irm::ObjectAttribute.multilingual.with_business_object_id.find(self.report_type_field.object_attribute_id)
  end


  def to_condition(table_name_hash)
    object_attribute = self.ref_object_attribute
    select_table_name = table_name_hash[self.ref_object_attribute[:business_object_id].to_s]
    operator_filter_value = parse_condition(object_attribute,self.operator_code,self.filter_value)|| "=#{select_table_name}.#{object_attribute.attribute_name}"
    "(#{select_table_name}.#{object_attribute.attribute_name} #{operator_filter_value})"
  end

  def clear_id
    tmp_id = self.id
    self.id = ""
    return tmp_id
  end

  private
  def validate_data_type_filter_value
    # if operator nil
    return if self.operator_code.eql?("NIL")
    object_attribute = self.ref_object_attribute
    operator = self.operator_code
    validate_filter_value = filter_value.dup
    validate_filter_value.strip!

    case object_attribute.data_type
      when 'int'
        validate_filter_value = process_param(validate_filter_value)
        validate_int(operator,validate_filter_value)
      when 'datetime'
        validate_filter_value = process_param(validate_filter_value)
        validate_date(operator,validate_filter_value)
      when 'varchar'
        validate_filter_value = process_param(validate_filter_value)
        validate_string(operator,validate_filter_value)
      when 'text'
        validate_filter_value = process_param(validate_filter_value)
        validate_string(operator,validate_filter_value)
    end
  end

  def process_param(filter_value)
    if filter_value.scan(/^\{\{(\S+)\}\}$/).length==1
      param = filter_value.scan(/^\{\{(\S+)\}\}$/).first.first
      info = ""
      if param.include?("destroy")||param.include?("update")
        info = "invalid key word"
        errors.add(:filter_value,I18n.t('activerecord.errors.messages.invalid'))
      end
      begin
        filter_value = eval(param).to_s
        rescue StandardError,SyntaxError=>text
          info = text
      end if info.blank?

      if !info.blank?
        errors.add(:filter_value,I18n.t('activerecord.errors.messages.invalid'))
      end
    end
    filter_value
  end

  def validate_int(operator,filter_value)
    if filter_value.scan(/\D/).length>0
      errors.add(:filter_value,I18n.t('activerecord.errors.messages.invalid'))
    end
  end

  def validate_date(operator,filter_value)
    if "IN".eql?(operator)
      errors.add(:filter_value,I18n.t('activerecord.errors.messages.invalid')) if filter_value.scan(/\D/).length>0
    elsif filter_value.scan(/[^\d\-]/).length>0
      errors.add(:filter_value,I18n.t('activerecord.errors.messages.invaliddate'))
    else
      info = ""
      begin
        Date.parse(filter_value)
        rescue ArgumentError=>text
          info = text
      end
      unless info.blank?&&filter_value.length>8
        errors.add(:filter_value,I18n.t('activerecord.errors.messages.invaliddate'))
      end
    end

  end

  def validate_string(operator,filter_value)
    if filter_value.scan(/\{\{\S+\}\}/).length>0
      errors.add(:filter_value,I18n.t('activerecord.errors.messages.invalid'))
    end
  end


  def parse_condition(object_attribute,operator,filter_value)
    filter_value.strip!
    case object_attribute.data_type
      when 'int'
        parse_int_condition(operator,filter_value)
      when 'datetime'
        parse_date_condition(operator,filter_value)
      when 'varchar'
        parse_string_condition(operator,filter_value)
      when 'text'
        parse_string_condition(operator,filter_value)
    end
  end

  def parse_string_condition(operator,filter_value)
    if filter_value.scan(/^\{\{\S+\}\}$/).length==1
      formated_filter_value = %Q(#{filter_value})
      case
        when OPERATORS[:common].include?(operator)
          parse_common_condition(operator,formated_filter_value)
        when 'BW'.eql?(operator)
          "LIKE '#{filter_value}%'"
        when 'EW'.eql?(operator)
          "LIKE '%#{filter_value}'"
        when 'U'.eql?(operator)
          "LIKE '%#{filter_value}%'"
        when 'X'.eql?(operator)
          "NOT LIKE '%#{filter_value}%'"
      end
    else
      formated_filter_value = %Q('#{filter_value}')
      case
        when OPERATORS[:common].include?(operator)
          parse_common_condition(operator,formated_filter_value)
        when 'BW'.eql?(operator)
          "LIKE '#{filter_value}%'"
        when 'EW'.eql?(operator)
          "LIKE '%#{filter_value}'"
        when 'U'.eql?(operator)
          "LIKE '%#{filter_value}%'"
        when 'X'.eql?(operator)
          "NOT LIKE '%#{filter_value}%'"
      end
    end
  end

  def parse_date_condition(operator,filter_value)
    formated_filter_value = %Q({{Date.parse('#{filter_value}')}})
    formated_filter_value = %Q(#{filter_value}) if filter_value.scan(/^\{\{\S+\}\}$/).length==1
    case
      when OPERATORS[:common].include?(operator)
        parse_common_condition(operator,formated_filter_value)
      when 'IN'.eql?(operator)
        "> {{Date.today-#{filter_value}}}"
    end
  end

  def parse_int_condition(operator,filter_value)
    formated_filter_value = %Q({{#{filter_value}}})
    formated_filter_value = %Q(#{filter_value}) if filter_value.scan(/^\{\{\S+\}\}$/).length==1
    case
      when OPERATORS[:common].include?(operator)
        parse_common_condition(operator,formated_filter_value)
    end
  end

  def parse_common_condition(operator,filter_value)
    case operator
      when "E"
        "= #{filter_value}"
      when 'N'
        "!= #{filter_value}"
      when 'L'
        "< #{filter_value}"
      when 'G'
        "> #{filter_value}"
      when 'M'
        "<= #{filter_value}"
      when 'L'
        ">= #{filter_value}"
      when 'NIL'
        " IS NULL"
      when 'NNIL'
        " IS NOT NULL"
    end
  end

end
