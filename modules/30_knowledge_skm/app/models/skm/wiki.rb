class Skm::Wiki < ActiveRecord::Base
  set_table_name :skm_wikis

  attr_accessor :origin_name, :sync_git_flag

  #加入activerecord的通用方法和scope
  query_extend
  #对运维中心数据进行隔离
  default_scope { default_filter }

  validates_presence_of :name, :description,:channel_id

  validates_uniqueness_of :name, :if => Proc.new { |i| i.name.present? }

  after_create do
    commit = {:message => self.description, :name => Irm::Person.current.login_name, :email => Irm::Person.current.email_address}
    page = Ironmine::WIKI.write_page(self.wiki_name, self.content_format.to_sym, self.content, commit)
  end

  before_update do
    self.origin_name = self.class.find(self.id).name
  end

  after_update do

    if (self.sync_git_flag.present?&&sync_git_flag.eql?(Irm::Constant::SYS_YES))||!self.sync_git_flag.present?
      commit = {:message => self.description, :name => Irm::Person.current.login_name, :email => Irm::Person.current.email_address}
      page = Ironmine::WIKI.page(self.origin_wiki_name)
      Ironmine::WIKI.update_page(page, self.wiki_name, self.content_format.to_sym, self.content, commit)
    end
  end

  scope :by_book, lambda { |book_id|
    joins("JOIN #{Skm::BookWiki.table_name} ON #{Skm::BookWiki.table_name}.book_id = '#{book_id}' AND #{Skm::BookWiki.table_name}.wiki_id = #{table_name}.id").
        order("#{Skm::BookWiki.table_name}.display_sequence")
  }

  scope :by_person, lambda { |person_id|
    where("(created_by = ? AND private_flag = ?) OR private_flag = ?", person_id, Irm::Constant::SYS_YES, Irm::Constant::SYS_NO)
  }

  # LOV额外处理方法
  def self.lov(lov_scope, params)
    if params[:lov_params].present?&&params[:lov_params].is_a?(Hash)&&params[:lov_params][:lktkn].present?
      #根据lov的使用不同,进行不同的处理
      if "add_to_books".eql?(params[:lov_params][:lktkn])&& params[:lov_params][:book_id].present?
        lov_scope = lov_scope.where("NOT EXISTS (SELECT 1 FROM #{Skm::BookWiki.table_name} where #{Skm::BookWiki.table_name}.book_id = ? AND wiki_id=#{self.table_name}.id)",  params[:lov_params][:book_id])
      end
    end

    lov_scope
  end

  def wiki_name
    "#{self.name} #{self.id}"
  end

  def versions
    page = Ironmine::WIKI.page(self.wiki_name)
    page.versions
  end

  #a = Skm::Jobs::StaticWikiJob.new('004U00094zD8SW6TpPYFyi')
  def page
    if @page
      return @page
    else
      #process flag from word
      if self.sync_flag.present?&&self.sync_flag.eql?(Irm::Constant::SYS_YES)
        Ironmine::WIKI.clear_cache
        self.sync_flag = Irm::Constant::SYS_NO
        self.sync_git_flag = Irm::Constant::SYS_NO
        self.save
      end
      @page = Ironmine::WIKI.page(self.wiki_name)
      unless @page
        begin
        commit = {:message => self.description, :name => Irm::Person.current.login_name, :email => Irm::Person.current.email_address}
        Ironmine::WIKI.write_page(self.wiki_name, self.content_format.to_sym, self.content, commit)
        @page = Ironmine::WIKI.page(self.wiki_name)
        rescue Exception => e
          nil
        end
      end
      return @page
    end

  end

  def page=(page)
    @page = page
  end

  def show_url(absolute = false)
    return "#" unless self.id
    if absolute
      Irm::GlobalHelper.instance.absolute_url(:controller => "skm/wikis", :action => "show", :id => self.id)
    else
      Irm::GlobalHelper.instance.url(:controller => "skm/wikis", :action => "show", :id => self.id)
    end

  end

  def md5_flag
    Digest::SHA1.hexdigest("#{self.updated_at.in_time_zone(8)}#{self.created_at.in_time_zone(8)}")
  end


  after_save do
    self.class.sync_static(self.id)
  end

  after_destroy do
    self.class.sync_static(self.id)
  end

  def self.sync_static(wiki_id)
    Skm::WikiToStatic.instance.sync_wiki_static(wiki_id)
  end


  protected

  def origin_wiki_name
    "#{self.origin_name} #{self.id}"
  end


end
