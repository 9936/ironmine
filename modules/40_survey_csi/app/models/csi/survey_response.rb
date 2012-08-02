# -*- coding: utf-8 -*-
class Csi::SurveyResponse < ActiveRecord::Base
  set_table_name :csi_survey_responses
  belongs_to :survey
  has_many :survey_results

  before_save :calculate_elapse

  validates_presence_of :survey_id

  attr_accessor :password

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}


  scope :with_person,lambda{
    joins("JOIN #{Irm::Person.table_name} ON #{Irm::Person.table_name}.id = #{table_name}.person_id").
        select("#{Irm::Person.table_name}.full_name person_name")
  }

  def self.list_all
    self.select_all.with_person
  end

  private

  def calculate_elapse
    self.elapse=self.end_at-self.start_at if self.end_at.present?&&self.start_at.present?
  end

end