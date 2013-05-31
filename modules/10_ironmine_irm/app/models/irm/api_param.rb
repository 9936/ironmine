class Irm::ApiParam < ActiveRecord::Base
  set_table_name :irm_api_params

  belongs_to :permission, :foreign_key => :permission_id

  validates_presence_of :permission_id
  validates_uniqueness_of :permission_id, :scope => [:name]
end