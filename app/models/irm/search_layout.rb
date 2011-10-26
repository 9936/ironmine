class Irm::SearchLayout < ActiveRecord::Base
  set_table_name :irm_search_layouts
  attr_accessor :columns_str

  has_many :search_layout_columns

  validates_presence_of :code

  validates_uniqueness_of :code ,:scope=>[:opu_id,:business_object_id] ,:if=>Proc.new{|i| i.code.present?}

  query_extend

  scope :with_code,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} code ON code.lookup_type='IRM_BO_SEARCH_LAYOUT' AND code.lookup_code = #{table_name}.code AND code.language= '#{language}'").
    select(" code.meaning code_name")
  }

    #创建 更新报表列
  def create_columns_from_str
    return unless self.columns_str
    str_values = self.columns_str.split(",").delete_if{|i| !i.present?}
    str_values_indexes = str_values.dup
    exists_values = Irm::SearchLayoutColumn.where(:search_layout_id=>self.id)
    exists_values.each do |value|
      if str_values.include?(value.object_attribute_id)
        str_values.delete(value.object_attribute_id)
        default_options = {}
        value.update_attributes({:seq_num=>str_values_indexes.index(value.object_attribute_id)+1}.merge(default_options))
      else
        value.destroy
      end

    end

    str_values.each do |value_str|
      next unless value_str.strip.present?
      default_options = {}
      self.search_layout_columns.build({:object_attribute_id=>value_str,:seq_num=>str_values_indexes.index(value_str)+1}.merge(default_options))
    end if str_values.any?
  end

  def get_columns_str
    return @get_columns_str if @get_columns_str
    @get_columns_str = Irm::SearchLayoutColumn.where(:search_layout_id=>self.id).collect{|value| value[:object_attribute_id]}.join(",")
  end
end
