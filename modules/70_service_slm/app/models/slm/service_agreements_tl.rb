class Slm::ServiceAgreementsTl < ActiveRecord::Base
  set_table_name :slm_service_agreements_tl

  belongs_to :service_agreement

  validates_presence_of :name
end