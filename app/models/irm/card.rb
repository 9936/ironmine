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
    lane_limit = 999999 if lane_limit == 0
    card_content_scope =
        case self.card_code
          when "IR_ARR_WAITING_FOR_REPLY"
            ir_arr_waiting_for_reply(lane_limit, accessable_companies)
          when "IR_CUSTOMER_REPLIED"
            ir_customer_replied(lane_limit, accessable_companies)
          else
            filter = Irm::RuleFilter.where(:source_type => Irm::Card.name, :source_id => self.id).first
            filter.generate_scope.select("'' card_url").order(self.date_attribute_name + " DESC").query_by_company_ids(accessable_companies)#.limit(lane_limit)
        end
    card_content_scope
  end

  private
  #新到达待回复的事故单
  def ir_arr_waiting_for_reply(lane_limit = 0, accessable_companies = [])
    ret_scope = []
    Icm::IncidentRequest.select("#{Icm::IncidentRequest.table_name}.*, '' card_url").
        where("NOT EXISTS(SELECT 1 FROM #{Icm::IncidentJournal.table_name} ij where ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND ij.replied_by = ?)", Irm::Person.current.id).
        where("#{Icm::IncidentRequest.table_name}.support_person_id = ?", Irm::Person.current.id).
        query_by_company_ids(accessable_companies).
        order("#{Icm::IncidentRequest.table_name}.updated_at DESC").each do |is|
          if !is.close? && is.need_customer_reply == Irm::Constant::SYS_NO
            ret_scope << is unless ret_scope.include?(is)
#            break if ret_scope.size == lane_limit
          end
    end
    ret_scope
  end

  #客户回复后的事故单
  def ir_customer_replied(lane_limit = 0, accessable_companies = [])
    ret_scope = []
    Icm::IncidentRequest.select("#{Icm::IncidentRequest.table_name}.*, '' card_url").
      select("#{Icm::IncidentRequest.table_name}.*, ij.updated_at ij_updated_at").
      joins(",#{Icm::IncidentJournal.table_name} ij").
      where("ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id").
      query_by_company_ids(accessable_companies).
      where("#{Icm::IncidentRequest.table_name}.support_person_id = ?", Irm::Person.current.id).
      where("EXISTS(SELECT 1 FROM #{Icm::IncidentJournal.table_name} ij2 where ij2.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND ij2.replied_by = ?)", Irm::Person.current.id).
      order("ij_updated_at DESC").each do |is|
        if !is.close? && is.need_customer_reply == Irm::Constant::SYS_NO
          ret_scope << is unless ret_scope.include?(is)
#          break if ret_scope.size == lane_limit
        end
    end
    ret_scope
  end
end