class Icm::GroupProcessRelation < ActiveRecord::Base
  set_table_name :icm_group_process_relations

  belongs_to :group_process, :class_name => "Icm::SystemGroupProcess", :foreign_key => "group_process_id"

  validates_presence_of :group_process_id, :support_group_from, :support_group_to

  validates_uniqueness_of :group_process_id, :scope => [:support_group_from, :support_group_to]

  scope :with_group_from_name, lambda { |language|
    joins("LEFT JOIN #{Icm::SupportGroup.multilingual_view_name} sgv0 ON sgv0.id = #{table_name}.support_group_from AND sgv0.language ='#{language}'").
        select("IF(sgv0.name is NULL, '#{I18n.t(:label_irm_system_group_process_blank)}', sgv0.name) support_from_name")
  }

  scope :with_group_to_name, lambda { |language|
    joins("JOIN #{Icm::SupportGroup.multilingual_view_name} sgv1 ON sgv1.id = #{table_name}.support_group_to AND sgv1.language ='#{language}'").
        select("sgv1.name support_to_name")
  }

  scope :with_process, lambda { |process_id|
    where("#{table_name}.group_process_id=?", process_id)
  }


  def self.list_all
    select_all.
        with_group_from_name(I18n.locale).
        with_group_to_name(I18n.locale)
  end

  scope :select_all, lambda {
    select("#{table_name}.*")
  }

  #scope :with_group_name,lambda{|group_process_id, language|
  #  joins("JOIN #{Icm::SupportGroup.view_name} sgv ON sgv.id = #{table_name}.support_group_to AND gv.language ='#{language}'").
  #  joins("JOIN #{Icm::SupportGroup.view_name} sgv ON sgv.id = #{table_name}.support_group_from AND gv.language ='#{language}'").
  #
  #      where("#{table_name}.group_process_id=?", group_process_id)
  #}

end