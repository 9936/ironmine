class Skm::EntryHeader < ActiveRecord::Base
  set_table_name :skm_entry_headers
  has_many :entry_subjects
  has_many :entry_details
  has_many :entry_approval_people, :class_name => "Skm::EntryApprovalPerson", :dependent => :destroy


  acts_as_searchable


  validates_presence_of :entry_title, :channel_id
  validate  :uniq_entry_title

  belongs_to :channel

  attr_accessor :published_date_f, :full_title
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter.within_accessible_columns}

#  acts_as_recently_objects(:title => "entry_title",
#                           :target_controller => "skm/entry_headers")
  def uniq_entry_title
    #puts self.inspect
    if(self.history_flag.eql?("N"))
      entry_header=Skm::EntryHeader.where("#{Skm::EntryHeader.table_name}.entry_title=?  and #{Skm::EntryHeader.table_name}.history_flag='N'",self.entry_title).limit(1)
      if self.id
        entry_header=entry_header.where(" #{Skm::EntryHeader.table_name}.id<>?",self.id)
      end
      #puts entry_header.inspect;
      if(entry_header.any?)
        self.errors.add(:entry_title,I18n.t(:error_value_existed))
      end
    end
  end
  # 默认进行频道权限过滤
  scope :within_accessible_columns, lambda{
    within_accessible_columns_c
  }
  scope :published, where("#{table_name}.entry_status_code = ?", "PUBLISHED")
  scope :draft, where("#{table_name}.entry_status_code = ?", "DRAFT")
  scope :current_entry, where("#{table_name}.history_flag = ?", Irm::Constant::SYS_NO)
  scope :history_entry, where("#{table_name}.history_flag = ?", Irm::Constant::SYS_YES)
  scope :list_all, select("#{table_name}.id,  #{table_name}.entry_template_id, #{table_name}.entry_title, #{table_name}.relation_id, #{table_name}.channel_id, #{table_name}.type_code" +
                              ", #{table_name}.keyword_tags, #{table_name}.doc_number, #{table_name}.history_flag, #{table_name}.entry_status_code" +
                              ", #{table_name}.version_number,  #{table_name}.published_date, #{table_name}.author_id, #{table_name}.status_code" +
                              ", #{table_name}.created_by, #{table_name}.created_at, #{table_name}.updated_by, #{table_name}.updated_at,  CONCAT('[', #{table_name}.doc_number, ']', #{table_name}.entry_title) full_title").
      order("#{table_name}.published_date DESC")

  #显示column_ids栏目中的文章，或未分类的文章
  scope :within_columns, lambda{|column_ids|
    where(" EXISTS (SELECT * FROM #{Skm::Channel.table_name} c, #{Skm::ChannelColumn.table_name} cc WHERE c.id = #{Skm::EntryHeader.table_name}.channel_id AND cc.channel_id = c.id AND cc.column_id IN (?))", columns + [''])
  }
  scope :with_author,lambda{
    joins("LEFT OUTER JOIN irm_people ON irm_people.id = #{table_name}.author_id").
        select("irm_people.full_name author_name")
  }
  scope :my_favorites, lambda{|person_id|
    joins(",#{Skm::EntryFavorite.table_name} ef").
    where("ef.entry_header_id = #{table_name}.id").
    where("ef.person_id = ?", person_id)
  }
  scope :with_entry_status,lambda{
    joins("LEFT OUTER JOIN irm_lookup_values_vl ON irm_lookup_values_vl.lookup_code=#{table_name}.entry_status_code and irm_lookup_values_vl.language='#{I18n.locale}'").
        select("irm_lookup_values_vl.meaning entry_status_name")
  }

  scope :my_drafts, lambda{|person_id|
    where("#{table_name}.author_id = ?", person_id).
    where("#{table_name}.entry_status_code = ?", "DRAFT")
  }

  scope :my_unpublished, lambda{|person_id|
    where("#{table_name}.author_id = ?", person_id).
    where("#{table_name}.entry_status_code"=>["WAIT_APPROVE","APPROVE_DENY"])
  }

  scope :wait_my_approve, lambda{
    where("#{table_name}.entry_status_code=? AND #{table_name}.id IN (?)", "WAIT_APPROVE", Skm::EntryApprovalPerson.query_approvals_by_person(Irm::Person.current.id).collect{|i|i[:entry_header_id]})
  }

  scope :query_by_day,select("DATE_FORMAT(#{table_name}.created_at,'%Y-%m-%d') created_day,sum(1) entry_count").
                      group("DATE_FORMAT(#{table_name}.created_at,'%Y-%m-%d')").
                      order("DATE_FORMAT(#{table_name}.created_at,'%Y-%m-%d') asc")

  scope :with_favorite_flag, lambda{|person_id|
    select("if(ef.id is null, 'Y', 'N') is_favorite").
    joins("LEFT OUTER JOIN #{Skm::EntryFavorite.table_name} ef ON ef.person_id = '#{person_id}' AND ef.entry_header_id = #{table_name}.id")
  }

  scope :max_number, lambda{|opu_id|
    select("MAX(CAST(#{table_name}.doc_number AS UNSIGNED)) dnum").
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
    search = Sunspot.search(Skm::EntryHeader, Irm::AttachmentVersion) do |sq|
      sq.keywords query
      sq.with(:source_type, 'Skm::EntryHeader')
      query.paginate(:page => params[:page], :per_page => 30)
    end
    #对result进行判断是否来自于附件，如果来自于附件需要对其进行特殊处理
    entry_header_ids = []
    if search.results.any?
      search.results.each do |result|
        if result.class.to_s.eql?('Irm::AttachmentVersion')
          entry_header_ids << result.source_id unless entry_header_ids.include?(result.source_id)
        else
          entry_header_ids << result.id unless entry_header_ids.include?(result.id)
        end
      end
    end
    Skm::EntryHeader.where("#{Skm::EntryHeader.table_name}.id IN (?)", entry_header_ids)
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