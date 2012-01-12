class Csi::SurveySubject < ActiveRecord::Base
  set_table_name :csi_survey_subjects

  belongs_to :survey
  has_many :subject_options, :foreign_key=>"survey_subject_id" ,:dependent => :destroy
  has_many :survey_results, :foreign_key => "subject_id"
  validates_presence_of :name,:display_sequence
  validates_uniqueness_of :name, :scope => "survey_id"
  TYPES = [['text', 'string'], ['paragraph_text', 'text'],
              ['multi_choice', 'radio'], ['checkboxes', 'check'],
              ['choose_from_a_list', 'drop'],
              ['page_break', 'page']]


  attr_accessor :options_str


  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}


  scope :query_by_subject_id,lambda{|subject_id|
                        select("#{table_name}.required_flag").
                        where(:id=>subject_id)
  }

  scope :query_by_choice_input,where("input_type not in ('string','text')")

  scope :order_by_id_desc,order("id desc")

  scope :order_by_seq_num, order("display_sequence ASC")

  scope :query_by_survey_id,lambda{|survey_id| where(:survey_id=>survey_id)}

  def self.get_max_display_sequence(survey_id)
     next_seq_num = self.query_by_survey_id(survey_id).maximum("display_sequence")
     if next_seq_num.blank?
       next_seq_num = 10
     else
       next_seq_num = (next_seq_num/10.round + 1)*10       
     end
     next_seq_num
  end

  def generate_options(values)
    exists_values = self.subject_options.order("display_sequence").collect{|i| i.value}
    max_sequence = 10
    max_sequence = exists_values.last.display_sequence+10 if exists_values.last
    values.each do |value|
      unless exists_values.include?(value)
        self.subject_options.build(:survey_subject_id=>self.id,:value=>value,:display_sequence=>max_sequence)
        max_sequence = max_sequence + 10
      end
    end
  end

end
