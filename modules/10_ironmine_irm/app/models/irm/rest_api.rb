class Irm::RestApi < ActiveRecord::Base
  set_table_name :irm_rest_apis

  validates_presence_of :name

  has_many :api_params, :foreign_key => :rest_api_id, :dependent => :destroy

end