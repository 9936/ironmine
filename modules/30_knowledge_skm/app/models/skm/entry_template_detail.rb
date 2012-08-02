class Skm::EntryTemplateDetail < ActiveRecord::Base
  set_table_name :skm_entry_template_details
  validates_presence_of :default_rows
  belongs_to :entry_template
  belongs_to :entry_template_element
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :owned_elements, lambda{|template_id|
    select("#{table_name}.*, te.name element_name, te.description element_description, '' entry_content, te.entry_template_element_code entry_template_element_code").
    joins(",#{Skm::EntryTemplateElement.table_name} te").
    where("#{table_name}.entry_template_element_id = te.id").
    where("#{table_name}.entry_template_id = ?", template_id).
    order("#{table_name}.line_num ASC")
  }

  def self.max_line_num(template_id)
    Skm::EntryTemplateDetail.where(:entry_template_id => template_id).order("line_num DESC").first().line_num
  rescue
    1
  end

  def self.min_line_num(template_id)
    Skm::EntryTemplateDetail.where(:entry_template_id => template_id).order("line_num ASC").first().line_num
  rescue
    1
  end
  
  def pre_detail
    pre_detail = Skm::EntryTemplateDetail.where(:entry_template_id => self.entry_template_id).where("line_num < ?", self.line_num).order("line_num DESC").first()
    if pre_detail then
      pre_detail
    else
      self
    end
  end

  def next_detail
    next_detail = Skm::EntryTemplateDetail.where(:entry_template_id => self.entry_template_id).where("line_num > ?", self.line_num).order("line_num ASC").first()
    if next_detail then
      next_detail 
    else
      self
    end
  end
end