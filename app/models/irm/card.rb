class Irm::Card < ActiveRecord::Base
  set_table_name :irm_cards
  has_many :lane_cards
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

  def prepare_card_content(lane_limit)
    card_content_scope =
        case self.card_code
          when "IR_WAITING_FOR_MY_REPLY"
            ir_waiting_for_my_reply
          when "IR_CUSTOMER_REPLIED"
            ir_customer_replied
          else
            filter = Irm::RuleFilter.where(:source_type => Irm::Card.name, :source_id => self.id).first
            filter.generate_scope.order(self.date_attribute_name + " DESC").limit(lane_limit)
        end

    card_content_scope
  end

  private
  #待我回复的事故单
  def ir_waiting_for_my_reply

  end

  #客户回复后的事故单
  def ir_customer_replied

  end
end