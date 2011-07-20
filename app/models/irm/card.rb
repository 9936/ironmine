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
    return_columns = [self.title_attribute_name.to_sym,
                      self.description_attribute_name.to_sym,
                      self.date_attribute_name.to_sym]
    bo = Irm::BusinessObject.where(:business_object_code => self.bo_code).first
    card_content_scope = eval(bo.generate_query_by_attributes(return_columns,true)).order(self.date_attribute_name + " DESC").limit(lane_limit)
    card_content_scope
  end
end