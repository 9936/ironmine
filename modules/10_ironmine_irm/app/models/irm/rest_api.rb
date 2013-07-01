class Irm::RestApi < ActiveRecord::Base
  set_table_name :irm_rest_apis

  validates_presence_of :name

  has_many :api_params, :foreign_key => :rest_api_id, :dependent => :destroy

  scope :query_by_controller_action, lambda {|controller, action|
    joins("JOIN #{Irm::Permission.table_name} p ON #{table_name}.permission_id=p.id").
        where("p.controller=? AND p.action=?", controller, action).
        select("#{table_name}.name")
  }

end