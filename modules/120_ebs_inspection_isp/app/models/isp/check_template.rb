class Isp::CheckTemplate < ActiveRecord::Base
  set_table_name :isp_check_templates

  belongs_to :program, :foreign_key => :program_id
  validates_presence_of :name, :program_id, :body

  attr_accessor_with_default :content_format,"markdown"

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_program, lambda{|program_id|
    where("#{table_name}.program_id=?", program_id)
  }

  def generate_html(context={})
    body=Liquid::Template.parse self.body
    str = body.render context.stringify_keys

    preview = Ironmine::WIKI.preview_page(self.name, str, self.content_format)
    doc = Nokogiri::HTML::DocumentFragment.parse(preview.formatted_data.force_encoding("utf-8"))

  end
end

