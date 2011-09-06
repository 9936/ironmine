class Irm::Bulletin < ActiveRecord::Base
  set_table_name :irm_bulletins

  has_many :bulletin_accesses
  validates_presence_of :title

  has_many :bulletin_columns
  has_many :bu_columns, :through => :bulletin_columns

  attr_accessor :column_ids,:access_str

  searchable do
    text :content
    text :title
  end

  scope :with_author, lambda{
    select("concat(pr.last_name, pr.first_name) author")
    joins(",#{Irm::Person.table_name} pr").
        where("pr.id = #{table_name}.author_id")
  }

  scope :accessible,lambda{|person_id|
      joins("JOIN #{Irm::BulletinAccess.table_name} ON #{Irm::BulletinAccess.table_name}.bulletin_id = #{table_name}.id").
      where("EXISTS(SELECT 1 FROM #{Irm::Person.relation_view_name} WHERE #{Irm::Person.relation_view_name}.source_id = #{Irm::BulletinAccess.table_name}.access_id AND #{Irm::Person.relation_view_name}.source_type = #{Irm::BulletinAccess.table_name}.access_type AND  #{Irm::Person.relation_view_name}.person_id = ?)",person_id)
  }

  scope :select_all, lambda{
    select("#{table_name}.id id, #{table_name}.title bulletin_title, #{table_name}.content, DATE_FORMAT(#{table_name}.created_at, '%Y/%c/%e %H:%I:%S') published_date").
        select("#{table_name}.page_views page_views, #{table_name}.sticky_flag")
  }

  scope :select_all_top, lambda{
    select("#{table_name}.id id, CONCAT('[#{I18n.t(:label_irm_bulletin_sticky_flag)}] ', #{table_name}.title) bulletin_title, #{table_name}.content, DATE_FORMAT(#{table_name}.created_at, '%Y/%c/%e %H:%I:%S') published_date").
        select("#{table_name}.page_views page_views, #{table_name}.sticky_flag")
  }

  scope :query_by_author, lambda{|author_id|
    where("#{table_name}.author_id=?", author_id)
  }

  scope :query_accessible_with_nothing, lambda{
    select("' ' name, ' ' type")
  }

  scope :without_access, lambda{
    where("NOT EXISTS (SELECT * FROM #{Irm::BulletinAccess.table_name} ba WHERE ba.bulletin_id = #{table_name}.id )")
  }

  scope :sticky, lambda{
    where("#{table_name}.sticky_flag='Y'")
  }

  scope :unsticky, lambda{
    where("#{table_name}.sticky_flag <> 'Y'")
  }

  scope :without_delete, lambda{
    where("#{table_name}.status_code <> 'DELETE'")
  }
  def self.list_all
    select_all.with_author
  end

  def self.current_accessible(companies = [])
    bulletins = Irm::Bulletin.select_all.accessible(Irm::Person.current.id).collect(&:id)
    bulletins
  end

  def get_column_ids
    self.bu_columns.enabled.collect(&:id).join(",")
  end



  # create access from str
  def create_access_from_str
    return unless self.access_str
    str_values = self.access_str.split(",").delete_if{|i| !i.present?}
    exists_values = Irm::BulletinAccess.where(:bulletin_id=>self.id)
    exists_values.each do |value|
      if str_values.include?("#{value.access_type}##{value.access_id}")
        str_values.delete("#{value.access_type}##{value.access_id}")
      else
        value.destroy
      end

    end

    str_values.each do |value_str|
      next unless value_str.strip.present?
      value = value_str.strip.split("#")
      self.bulletin_accesses.create(:access_type=>value[0],:access_id=>value[1])
    end
  end

  def get_access_str
    return @get_access_str if @get_access_str
    @get_access_str = Irm::BulletinAccess.where(:bulletin_id=>self.id).collect{|value| "#{value.access_type}##{value.access_id}"}.join(",")
  end

end