class Skm::EntryBook < ActiveRecord::Base
  set_table_name :skm_entry_books

  #多语言关系
  attr_accessor :name,:description, :preference_book_id
  has_many :entry_books_tls, :foreign_key => "book_id",  :dependent => :destroy
  has_many :entry_book_relations, :foreign_key => "book_id",  :dependent => :destroy

  acts_as_multilingual

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :query_books_by_relations, lambda{|book_id|
    joins("JOIN #{Skm::EntryBookRelation.table_name} sebr ON #{table_name}.id=sebr.target_id").
        where("sebr.book_id=? AND sebr.relation_type=?", book_id, "ENTRYBOOK").
        select("sebr.relation_type, sebr.id, #{table_name}.id entry_book_id")
  }

  scope :with_author, lambda{|author_id|
    where("#{table_name}.created_by=?", author_id)
  }

  scope :with_project, lambda{|project_id|
    where("#{table_name}.project_id=?", project_id)
  }

  scope :with_login_name, lambda{|login_name|
    #joins("JOIN #{Irm::Person.table_name} p on p.id=#{table_name}.created_by").
    where("p.login_name=?", login_name)
  }

  scope :with_person, lambda {
    joins("JOIN #{Irm::Person.table_name} p on p.id=#{table_name}.created_by").
        select("#{table_name}.*, p.full_name author_name")
  }

  def self.within_accessible_columns(column_id=nil)
    within_accessible_columns_c(column_id)
  end

  def self.within_accessible_columns_c(column_id=nil)
    columns = Skm::Column.current_person_accessible_columns
    if column_id and column = Skm::Column.where("id=?",column_id).first
      column_ids = column.recursive_columns.delete_if{|i| !columns.include?(i)}
      columns = column_ids
    end
    where(" EXISTS (SELECT * FROM #{Skm::Channel.table_name} c, #{Skm::ChannelColumn.table_name} cc WHERE c.id = #{Skm::EntryBook.table_name}.channel_id AND cc.channel_id = c.id AND cc.column_id IN (?))", columns + [''])
  end


  def self.lov(lov_scope, params)
    if params[:lov_params].present?&&params[:lov_params].is_a?(Hash)&&params[:lov_params][:lktkn].present?
      #根据不同的来源的lov进行特殊的过滤处理
      if "entry_book_relation".eql?(params[:lov_params][:lktkn])&& params[:lov_params][:entry_book_id].present?
        lov_scope = lov_scope.where("#{self.view_name}.id !=? AND NOT EXISTS(SELECT 1 FROM #{Skm::EntryBookRelation.table_name} sebr WHERE((#{self.view_name}.id=sebr.book_id OR #{self.view_name}.id=sebr.target_id) AND (sebr.relation_type='ENTRYBOOK') AND (sebr.book_id=? OR sebr.target_id=?) ))", params[:lov_params][:entry_book_id],params[:lov_params][:entry_book_id],params[:lov_params][:entry_book_id])
      end
    end
    lov_scope
  end


  def entry_books
    Skm::EntryBook.joins("JOIN #{Skm::EntryBookRelation.table_name} sebr ON #{table_name}.id=sebr.target_id").
        where("sebr.book_id=? AND sebr.relation_type=?", self.id, "ENTRYBOOK")
  end

  def entry_headers
    Skm::EntryHeader.joins("JOIN #{Skm::EntryBookRelation.table_name} sebr ON #{Skm::EntryHeader.table_name}.id = sebr.target_id").
        where("sebr.book_id=? AND sebr.relation_type=?", self.id, "ENTRYHEADER")
  end


end
