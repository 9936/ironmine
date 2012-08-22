class ReindexForHli < ActiveRecord::Migration
  def up
    indexes(:icm_incident_requests).each do |i|
      remove_index(:icm_incident_requests, :name => i.name)
    end
    add_index "icm_incident_requests", ["opu_id"], :name => "ICM_INCIDENT_REQUESTS_N1"
    add_index "icm_incident_requests", ["incident_status_id", "next_reply_user_license", "last_request_date", "last_response_date"],
              :name => "ICM_INCIDENT_REQUESTS_N2"

    indexes(:irm_attachment_versions).each do |i|
      remove_index(:irm_attachment_versions, :name => i.name)
    end
    add_index "irm_attachment_versions", ["source_id", "source_type"], :name => "IRM_ATTACHMENT_VERSIONS_N1"

    indexes(:irm_watchers).each do |i|
      remove_index(:irm_watchers, :name => i.name)
    end
    add_index "irm_watchers", ["opu_id", "watchable_id", "watchable_type"], :name => "IRM_WATCHERS_N1"
    add_index "irm_watchers", ["opu_id", "member_id", "watchable_id", "member_type"], :name => "IRM_WATCHERS_N2"
    add_index "irm_watchers", ["member_id", "watchable_id", "member_type", "watchable_type"], :name => "IRM_WATCHERS_U1", :unique => true

    indexes(:irm_person_relations_tmp).each do |i|
      remove_index(:irm_person_relations_tmp, :name => i.name)
    end
    add_index "irm_person_relations_tmp", ["source_id"], :name => "IRM_PERSON_RELATIONS_TMP_N1"
    add_index "irm_person_relations_tmp", ["person_id"], :name => "IRM_PERSON_RELATIONS_TMP_N2"
  end

  def down
  end
end
