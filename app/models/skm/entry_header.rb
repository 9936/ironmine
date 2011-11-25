class Skm::EntryHeader < ActiveRecord::Base
  set_table_name :skm_entry_headers
  has_many :entry_subjects
  has_many :entry_details

  acts_as_searchable

  validates_presence_of :entry_title, :channel_id

  belongs_to :channel

  attr_accessible :published_date_f, :full_title
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter.within_accessible_columns}

#  acts_as_recently_objects(:title => "entry_title",
#                           :target_controller => "skm/entry_headers")
  # 默认进行频道权限过滤
  scope :within_accessible_columns, lambda{
    within_accessible_columns_c
  }
  scope :published, where("#{table_name}.entry_status_code = ?", "PUBLISHED")
  scope :draft, where("#{table_name}.entry_status_code = ?", "DRAFT")
  scope :current_entry, where("#{table_name}.history_flag = ?", Irm::Constant::SYS_NO)
  scope :history_entry, where("#{table_name}.history_flag = ?", Irm::Constant::SYS_YES)
  scope :list_all, select("#{table_name}.id,  #{table_name}.entry_template_id, #{table_name}.entry_title" +
                              ", #{table_name}.keyword_tags, #{table_name}.doc_number, #{table_name}.history_flag, #{table_name}.entry_status_code" +
                              ", #{table_name}.version_number, DATE_FORMAT(#{table_name}.published_date , '%Y/%c/%e %H:%I:%S') published_date_f, #{table_name}.published_date, #{table_name}.author_id, #{table_name}.status_code" +
                              ", #{table_name}.created_by, #{table_name}.created_at, #{table_name}.updated_by, #{table_name}.updated_at,  CONCAT('[', #{table_name}.doc_number, ']', #{table_name}.entry_title) full_title").
      order("#{table_name}.published_date DESC")

  #显示column_ids栏目中的文章，或未分类的文章
  scope :within_columns, lambda{|column_ids|
    where(" EXISTS (SELECT * FROM #{Skm::Channel.table_name} c, #{Skm::ChannelColumn.table_name} cc WHERE c.id = #{Skm::EntryHeader.table_name}.channel_id AND cc.channel_id = c.id AND cc.column_id IN (?))", columns + [''])
  }

  scope :my_favorites, lambda{|person_id|
    joins(",#{Skm::EntryFavorite.table_name} ef").
    where("ef.entry_header_id = #{table_name}.id").
    where("ef.person_id = ?", person_id)
  }

  scope :my_drafts, lambda{|person_id|
    where("#{table_name}.author_id = ?", person_id).
    where("#{table_name}.entry_status_code = ?", "DRAFT")
  }

  scope :query_by_day,select("DATE_FORMAT(#{table_name}.created_at,'%Y-%m-%d') created_day,sum(1) entry_count").
                      group("DATE_FORMAT(#{table_name}.created_at,'%Y-%m-%d')").
                      order("DATE_FORMAT(#{table_name}.created_at,'%Y-%m-%d') asc")

  scope :with_favorite_flag, lambda{|person_id|
    select("if(ef.id is null, 'Y', 'N') is_favorite").
    joins("LEFT OUTER JOIN #{Skm::EntryFavorite.table_name} ef ON ef.person_id = '#{person_id}' AND ef.entry_header_id = #{table_name}.id")
  }

  scope :max_number, lambda{|opu_id|
    select("MAX(#{table_name}.doc_number) dnum").
        where("#{table_name}.opu_id = ?", opu_id)
  }

  scope :with_columns, lambda{|column_ids|
    joins(", #{Skm::Channel.table_name} c, #{Skm::ChannelColumn.table_name} cc").
        where("c.id = #{table_name}.channel_id AND cc.channel_id = c.id AND cc.column_id IN (?)", column_ids + [''])
  }

  searchable :auto_index => true, :auto_remove => true do
    text :entry_title, :boost => 3
    text :entry_content do |entry|
      entry.entry_details.map { |detail| detail.entry_content }
    end
    text :keyword_tags
    string :entry_status_code
    string :history_flag
    string :published_date
  end

  def self.search(query)
#    Skm::EntryHeader.list_all.published.current_entry.where("#{table_name}.entry_title like ? OR #{table_name}.doc_number like ?","%#{query}%","%#{query}%")
    Sunspot.search Skm::EntryHeader do
      keywords query
    end.results
  end

  def self.generate_doc_number(prefix = "")
#      num = Time.now.strftime("%y%m%d").to_i * 1000000 + rand(10)
#      return prefix + num.to_s
    num = Skm::EntryHeader.max_number(Irm::OperationUnit.current.id).first[:dnum].to_i + 1
    return num
  rescue
    return 1
  end

  def next_version_number
    self.version_number.blank? ? "1" : (self.version_number.to_i + 1)
  end

  def to_html
    self.entry_title
  end

  def attachments
    Irm::Attachment.list_all.query_by_source(Skm::EntryHeader.name, self.id)
  end

  def self.within_accessible_columns_c
    columns = Skm::Column.current_person_accessible_columns
    where(" EXISTS (SELECT * FROM #{Skm::Channel.table_name} c, #{Skm::ChannelColumn.table_name} cc WHERE c.id = #{Skm::EntryHeader.table_name}.channel_id AND cc.channel_id = c.id AND cc.column_id IN (?))", columns + [''])
  end

  def published_date_f
    self.published_date.strftime("%F %T")
  end

  def full_title
    "[" + self.doc_number + "] " + self.entry_title
  end
end