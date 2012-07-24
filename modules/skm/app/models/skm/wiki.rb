class Skm::Wiki < ActiveRecord::Base
  set_table_name :skm_wikis

  attr_accessor :origin_name

  #加入activerecord的通用方法和scope
  query_extend
  #对运维中心数据进行隔离
  default_scope {default_filter}

  validates_presence_of :name,:description

  validates_uniqueness_of :name,:if=>Proc.new{|i| i.name.present?}

  after_create do
    commit = {:message=>self.description,:name=>Irm::Person.current.login_name,:email=>Irm::Person.current.email_address}
    page = Ironmine::WIKI.write_page(self.wiki_name,self.content_format.to_sym, self.content, commit)
  end

  before_update do
    self.origin_name = self.class.find(self.id).name
  end

  after_update do
    commit = {:message=>self.description,:name=>Irm::Person.current.login_name,:email=>Irm::Person.current.email_address}
    page = Ironmine::WIKI.page(self.origin_wiki_name)
    Ironmine::WIKI.update_page(page, self.wiki_name, self.content_format.to_sym, self.content, commit)
  end

  scope :by_book,lambda{ |book_id|
    joins("JOIN #{Skm::BookWiki.table_name} ON #{Skm::BookWiki.table_name}.book_id = '#{book_id}' AND #{Skm::BookWiki.table_name}.wiki_id = #{table_name}.id").
        order("#{Skm::BookWiki.table_name}.display_sequence")
  }

  def wiki_name
    "#{self.name} #{self.id}"
  end

  def versions
    page = Ironmine::WIKI.page(self.wiki_name)
    page.versions
  end

  def page
    Ironmine::WIKI.page(self.wiki_name)
  end

  def show_url(absolute = false)
    return "#" unless self.id
    if absolute
      Irm::GlobalHelper.instance.absolute_url(:controller=>"skm/wikis",:action=>"show",:id=>self.id)
    else
      Irm::GlobalHelper.instance.url(:controller=>"skm/wikis",:action=>"show",:id=>self.id)
    end

  end


  protected

  def origin_wiki_name
    "#{self.origin_name} #{self.id}"
  end


end
