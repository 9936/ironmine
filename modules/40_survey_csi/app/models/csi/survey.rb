class Csi::Survey < ActiveRecord::Base
  set_table_name :csi_surveys

  attr_accessor :range_str ,:page

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  acts_as_searchable


  validates_presence_of :title
  #validates_presence_of :due_dates,:if=>Proc.new{|i| i.incident_flag.eql?(Irm::Constant::SYS_YES)}
  validates_presence_of :close_date,:if=>Proc.new{|i| i.incident_flag.eql?(Irm::Constant::SYS_NO)}


  has_many :todo_events, :as => :source

  has_many :survey_subjects
  has_many :survey_members
  has_many :survey_ranges
  has_many :survey_responses

  scope :query_by_person_id,lambda{|person_id| where(:person_id=>person_id)}

  scope :query_survey_by_day,lambda{
    select("#{table_name}.title, count(*) total_count, DATE_FORMAT(#{Csi::SurveyResponse.table_name}.created_at,'%Y-%m-%d') date").
        joins("JOIN #{Csi::SurveyResponse.table_name} ON #{table_name}.id = #{Csi::SurveyResponse.table_name}.survey_id").
        group("#{table_name}.title,DATE_FORMAT(#{Csi::SurveyResponse.table_name}.created_at,'%Y-%m-%d')")
        #order("")
  }

  scope :query_chart_data,lambda{
    select("count(*) total_count, DATE_FORMAT(#{Csi::SurveyResponse.table_name}.created_at,'%Y-%m-%d') date").
            joins("JOIN #{Csi::SurveyResponse.table_name} ON #{table_name}.id = #{Csi::SurveyResponse.table_name}.survey_id").
            group("DATE_FORMAT(#{Csi::SurveyResponse.table_name}.created_at,'%Y-%m-%d')")
  }


  scope :with_person_count, lambda{
    select(" 0 person_count")
  }

  scope :with_author,lambda{
    joins("JOIN #{Irm::Person.table_name} author ON #{table_name}.created_by = author.id").
        select("author.full_name author_name")
  }


  scope :query_recently_ten_reply,lambda{
    select("#{table_name}.id, #{table_name}.title title, sr.updated_at updated_at").
      joins(",#{Csi::SurveySubject.table_name} ss, #{Csi::SurveyResult.table_name} sr").
      where("ss.survey_id = #{table_name}.id").
      where("sr.subject_id = ss.id").
      where("sr.updated_at = (SELECT MAX(srr.updated_at) FROM #{Csi::SurveyResult.table_name} srr WHERE srr.subject_id = ss.id)").
      order("sr.updated_at DESC")
  }

  scope :query_recently_ten_update,lambda{
    select("#{table_name}.id, #{table_name}.title title, #{table_name}.updated_at updated_at").order("#{table_name}.updated_at DESC")

  }



  def self.list_all
    self.select_all.with_author.status_meaning
  end


  def self.search(query)
    self.where("#{table_name}.title like ?","%#{query}%")
  end

  def total_page
    @total_page ||= (self.survey_subjects.select{|f| f.input_type == 'page'}.length + 1)
  end

  def find_subjects_by_page(page)
    subjects = self.survey_subjects.sort {|f1, f2| f1.seq_num <=> f2.seq_num}
    pages = subjects.select{|f| f.input_type == 'page'}
    pages.insert(0, nil)
    pages << nil

    if pages.length > 2
      start = pages[(page) -1].nil? ? 0 : pages[(page) -1].seq_num
      stop  = pages[page].nil? ? 65535 : pages[page].seq_num
      subjects.select {|f| f.seq_num > start && f.seq_num < stop}
    else
      subjects
    end
  end

  def self.find_recently_ten
    recently_reply = query_recently_ten_reply
    recently_updated = query_recently_ten_update

    recently = recently_reply.uniq + recently_updated.uniq
    recently = recently.sort{|x, y| y[:updated_at] <=> x[:updated_at] }

    recently.each do |r|
      r.attributes.except(:updated_at)
    end
    recently.uniq
  end

  def current_author?
    if (self.created_by&&Irm::Person.current.id.eql?(self.created_by)) || (Irm::Person.current.login_name=="admin")
      Irm::Constant::SYS_YES
    else
      Irm::Constant::SYS_NO
    end
  end

  def to_s
    self.title
  end


  def close?
    self.close_date.present?&&self.close_date < Time.now.to_date
  end


  def last_page?(page)
    self.total_page <= page
  end

  def joined_count
    Csi::SurveyMember.query_by_survey_id(self.id).where(:response_flag=>Irm::Constant::SYS_YES).count
  end


  def generate_member
    return if Irm::Constant::SYS_YES.eql?(self.incident_flag)
    exists_member_ids = survey_members.collect{|i| i.person_id}
    person_ids = Csi::SurveyRange.where(:survey_id=>self.id).query_person_ids.collect{|i| i[:person_id]}
    person_ids.uniq!
    person_ids.each do |pid|
      if exists_member_ids.include?(pid)
        sm = Csi::SurveyMember.where(:survey_id=>self.id,:person_id=>pid).first
        sm.update_attributes(:end_date_active=>self.close_date) if sm
      else
        Csi::SurveyMember.create(:survey_id=>self.id,:person_id=>pid,:required_flag=>"N",:response_flag=>Irm::Constant::SYS_NO,:end_date_active=>self.close_date)
      end
    end
    exists_member_ids = exists_member_ids + person_ids
    exists_member_ids.uniq

  end

  def has_any_subjects?
    self.survey_subjects.any?
  end

  def clear_member
    Csi::SurveyMember.delete_all(["survey_id = ? AND response_flag = ?",self.id,Irm::Constant::SYS_NO])
  end

  def self.current_accessible(companies = [])
    Csi::SurveyMember.list_all.query_by_person(Irm::Person.current.id).collect(&:survey_id)
  end


  # create range from str
  def create_range_from_str
    return unless self.range_str
    str_values = self.range_str.split(",").delete_if{|i| !i.present?}
    exists_values = Csi::SurveyRange.where(:survey_id=>self.id)
    exists_values.each do |value|
      if str_values.include?("#{value.source_type}##{value.source_id}")
        str_values.delete("#{value.source_type}##{value.source_id}")
      else
        value.destroy
      end

    end

    str_values.each do |value_str|
      next unless value_str.strip.present?
      value = value_str.strip.split("#")
      self.survey_ranges.create(:source_type=>value[0],:source_id=>value[1])
    end
  end

  def get_range_str
    return @get_range_str if @get_range_str
    @get_range_str = Csi::SurveyRange.where(:survey_id=>self.id).collect{|value| "#{value.source_type}##{value.source_id}"}.join(",")
  end


end
