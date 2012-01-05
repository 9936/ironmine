class Chm::ChangeTask < ActiveRecord::Base
  set_table_name :chm_change_tasks

  belongs_to :source,:polymorphic=>true

  belongs_to :change_task_phase

  has_many :change_task_depends,:dependent => :destroy

  has_many :target_task_depends,:class_name=>"Chm::ChangeTaskDepend",:foreign_key=>:depend_task_id,:dependent => :destroy


  validates_presence_of :name,:status,:change_task_phase_id


  acts_as_task({
                 :scope=>"as_task",
                 :show_url  => {:controller => "chm/change_tasks", :action => "edit",:id=>:id},
                 :title => :task_title,
                 :status_name=>:status_name,
                 :start_at=>:start_at,
                 :end_at=>:end_at
                })



  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}


  # 查询出优先级
  scope :with_support,lambda{|language|
    joins("LEFT OUTER JOIN #{Icm::SupportGroup.multilingual_view_name} support_group ON  #{table_name}.support_group_id = support_group.id AND support_group.language= '#{language}'").
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} support_person ON  #{table_name}.support_person_id = support_person.id").
    select(" support_group.name support_group_name,support_person.full_name support_person_name")
  }

  scope :with_change_task_phase,lambda{|language|
    joins("LEFT OUTER JOIN #{Chm::ChangeTaskPhase.view_name} change_task_phase ON #{table_name}.change_task_phase_id = change_task_phase.id AND change_task_phase.language='#{language}'").
    select("change_task_phase.name change_task_phase_name")
  }

  # 紧急度
  scope :with_change_status,lambda{|language|
    joins("LEFT OUTER JOIN #{Chm::ChangeStatus.view_name} status ON  #{table_name}.status = status.id AND status.language= '#{language}'").
    select(" status.name status_name")
  }

  # 变更单
  scope :with_change_request,lambda{
    joins("JOIN #{Chm::ChangeRequest.table_name} ON #{table_name}.source_id = #{Chm::ChangeRequest.table_name}.id").
        where("#{table_name}.source_type = ?",Chm::ChangeRequest.name).
        select("#{Chm::ChangeRequest.table_name}.title change_request_title,#{Chm::ChangeRequest.table_name}.request_number change_request_number")
  }

  def self.list_all
    select_all.with_change_request.with_support(I18n.locale).with_change_task_phase(I18n.locale).with_change_status(I18n.locale)
  end


  def self.as_task
    self.list_all.with_change_status(I18n.locale).where(:support_person_id=>Irm::Person.current.id)
  end

  def task_title
    "[#{self[:change_request_number]}]#{self[:change_request_title]}:#{self[:name]}"
  end


  def depend_task_ids
    return @depend_task_ids if @depend_task_ids
    @depend_task_ids = self.change_task_depends.collect{|i| i.depend_task_id}
  end

  def create_from_depend_task_ids(task_ids)
    return unless task_ids.is_a?(Array)&&task_ids.any?
    exists_depend_tasks = Chm::ChangeTaskDepend.where(:change_task_id=>self.id)
    exists_depend_tasks.each do |task|
      if task_ids.include?(task.depend_task_id)
        task_ids.delete(task.depend_task_id)
      else
        task.destroy
      end
    end

    task_ids.each do |depend_task_id|
      next unless depend_task_id
      self.change_task_depends.build({:depend_task_id=>depend_task_id})
    end if task_ids.any?
  end

end
