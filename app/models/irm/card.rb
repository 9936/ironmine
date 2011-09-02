class Irm::Card < ActiveRecord::Base
  set_table_name :irm_cards
  has_many :lane_cards,:dependent => :destroy
  has_many :lanes, :through => :lane_cards
  attr_accessor :step
  attr_accessor :name,:description
  has_many :cards_tls,:dependent => :destroy
  acts_as_multilingual
  query_extend

  validates_presence_of :bo_code

  scope :select_all, lambda{
    select("#{table_name}.*")
  }

  scope :without_lane, lambda{|lane_id|
    joins(",#{Irm::CardsTl.table_name} ct").
        where("ct.card_id = #{table_name}.id").
        where("ct.language = ?", I18n.locale).
        where("NOT EXISTS(SELECT 1 FROM #{Irm::LaneCard.table_name} lc WHERE lc.lane_id = ? AND lc.card_id = #{table_name}.id)", lane_id).
        select("ct.name card_name, ct.description card_description")
  }

  def prepare_card_content(lane_limit, accessable_companies)

    card_content_scope =
        case self.card_code
          when "IR_WAITING_MY_REPLY"
            ir_waiting_my_reply
          when "IR_WAITING_MY_SOLUTION"
            ir_waiting_my_solution
          when "IR_WAITING_HELPDESK_REPLY"
            ir_waiting_helpdesk_reply
          when "IR_WAITING_CUSTOMER_REPLY"
            ir_waiting_customer_reply
          when "IR_MY_SUBMIT"
            ir_my_submit
          when "IR_MY_RELATION"
            ir_my_relation
          else
            filter = Irm::RuleFilter.where(:source_type => Irm::Card.name, :source_id => self.id).first
            filter.generate_scope.select("'' card_url").order(self.date_attribute_name + " DESC")
        end
    card_content_scope
  end

  private

############################################################################################################
  def ir_waiting_my_reply()
    ret_scope = []
    Icm::IncidentRequest.select("#{Icm::IncidentRequest.table_name}.*, '' card_url").
        where("#{Icm::IncidentRequest.table_name}.requested_by = ?", Irm::Person.current.id).
        where("#{Icm::IncidentRequest.table_name}.next_reply_user_license = ?", "REQUESTER").
        with_incident_status(I18n.locale).
        where("LENGTH(#{Icm::IncidentRequest.table_name}.external_system_id) > 0").
        where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", Irm::Person.current.system_ids).
        where("incident_status.close_flag <> ?", Irm::Constant::SYS_YES).
        order("#{Icm::IncidentRequest.table_name}.updated_at DESC").each do |is|
            ret_scope << is unless ret_scope.include?(is)
        end
    ret_scope
  end

  def ir_waiting_my_solution()
    ret_scope = []
    Icm::IncidentRequest.select("#{Icm::IncidentRequest.table_name}.*, '' card_url").
        where("#{Icm::IncidentRequest.table_name}.support_person_id = ?", Irm::Person.current.id).
        where("#{Icm::IncidentRequest.table_name}.next_reply_user_license = ?", "SUPPORTER").
        with_incident_status(I18n.locale).
        where("LENGTH(#{Icm::IncidentRequest.table_name}.external_system_id) > 0").
        where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", Irm::Person.current.system_ids).
        where("incident_status.close_flag <> ?", Irm::Constant::SYS_YES).
        order("#{Icm::IncidentRequest.table_name}.updated_at DESC").each do |is|
            ret_scope << is unless ret_scope.include?(is)
        end
    ret_scope
  end

  def ir_waiting_helpdesk_reply()
    ret_scope = []
    Icm::IncidentRequest.select("#{Icm::IncidentRequest.table_name}.*, '' card_url").
        where("#{Icm::IncidentRequest.table_name}.requested_by = ?", Irm::Person.current.id).
        where("#{Icm::IncidentRequest.table_name}.next_reply_user_license = ?", "SUPPORTER").
        with_incident_status(I18n.locale).
        where("LENGTH(#{Icm::IncidentRequest.table_name}.external_system_id) > 0").
        where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", Irm::Person.current.system_ids).
        where("incident_status.close_flag <> ?", Irm::Constant::SYS_YES).
        order("#{Icm::IncidentRequest.table_name}.updated_at DESC").each do |is|
            ret_scope << is unless ret_scope.include?(is)
        end
    ret_scope
  end

  def ir_waiting_customer_reply()
    ret_scope = []
    Icm::IncidentRequest.select("#{Icm::IncidentRequest.table_name}.*, '' card_url").
        where("#{Icm::IncidentRequest.table_name}.support_person_id = ?", Irm::Person.current.id).
        where("#{Icm::IncidentRequest.table_name}.next_reply_user_license = ?", "REQUESTER").
        with_incident_status(I18n.locale).
        where("LENGTH(#{Icm::IncidentRequest.table_name}.external_system_id) > 0").
        where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", Irm::Person.current.system_ids).
        where("incident_status.close_flag <> ?", Irm::Constant::SYS_YES).
        order("#{Icm::IncidentRequest.table_name}.updated_at DESC").each do |is|
            ret_scope << is unless ret_scope.include?(is)
        end
    ret_scope
  end

  def ir_my_submit()
    ret_scope = []
    Icm::IncidentRequest.select("#{Icm::IncidentRequest.table_name}.*, '' card_url").
        where("#{Icm::IncidentRequest.table_name}.submitted_by = ?", Irm::Person.current.id).
        with_incident_status(I18n.locale).
        where("LENGTH(#{Icm::IncidentRequest.table_name}.external_system_id) > 0").
        where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", Irm::Person.current.system_ids).
        where("incident_status.close_flag <> ?", Irm::Constant::SYS_YES).
        order("#{Icm::IncidentRequest.table_name}.updated_at DESC").each do |is|
            ret_scope << is unless ret_scope.include?(is)
        end
    ret_scope
  end

  def ir_my_relation()
    ret_scope = []
    Icm::IncidentRequest.select("#{Icm::IncidentRequest.table_name}.*, '' card_url").
        where("#{Icm::IncidentRequest.table_name}.support_person_id <> ?", Irm::Person.current.id).
        where("#{Icm::IncidentRequest.table_name}.requested_by <> ?", Irm::Person.current.id).
        with_incident_status(I18n.locale).
        relate_person(Irm::Person.current.id).
        where("LENGTH(#{Icm::IncidentRequest.table_name}.external_system_id) > 0").
        where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", Irm::Person.current.system_ids).
        where("incident_status.close_flag <> ?", Irm::Constant::SYS_YES).
        order("#{Icm::IncidentRequest.table_name}.updated_at DESC").each do |is|
            ret_scope << is unless ret_scope.include?(is)
        end
    ret_scope
  end
end