class Csi::SurveyMember < ActiveRecord::Base
  set_table_name :csi_survey_members

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  acts_as_urlable(:show=>{:controller=>"csi/surveys",:action=>"reply",:id=>:survey_id})


  acts_as_task({
                 :scope=>"as_task",
                 :show_url  => {:controller => "csi/survey_responses", :action => "new", :survey_member_id => :id,:survey_id=>:survey_id},
                 :title => :title,
                 :status_name=>nil,
                 :start_at=>:created_at,
                 :end_at=>:end_date_active
                })


  belongs_to :survey

  validates_uniqueness_of :person_id,:scope=>[:survey_id,:opu_id],:if=>Proc.new{|i| i.source_id.nil?}
  validates_uniqueness_of :person_id,:scope=>[:survey_id,:source_id,:opu_id],:if=>Proc.new{|i| !i.source_id.nil?}


  scope :query_by_survey_id,lambda{|survey_id| where(:survey_id => survey_id)}
  scope :query_by_person_id,lambda{|person_id| where(:person_id => person_id)}
  scope :query_by_response_flag,lambda{|response_flag| where(:response_flag=>response_flag)}

  scope :query_by_end_date_active,where("#{table_name}.end_date_active >= now() or  IsNull(#{table_name}.end_date_active)")
  
  scope :query_by_person,lambda{|person_id|
    where(:person_id=>person_id)
  }


  scope :with_survey,lambda{
    joins("JOIN #{Csi::Survey.table_name} ON #{Csi::Survey.table_name}.id = #{table_name}.survey_id").
    select("#{Csi::Survey.table_name}.title, #{Csi::Survey.table_name}.close_date")
  }

  def self.list_all
    select("#{table_name}.*").with_survey
  end


  def respond?
    self.end_date_active.nil?||self.end_date_active<Date.today||Irm::Constant::SYS_YES.eql?(self.response_flag)
  end


  def self.as_task
    self.list_all.query_by_person(Irm::Person.current.id).where(:response_flag=>Irm::Constant::SYS_NO).order("response_flag,created_at  desc")
  end

end