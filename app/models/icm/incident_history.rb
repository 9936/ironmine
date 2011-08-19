class Icm::IncidentHistory < ActiveRecord::Base
  set_table_name :icm_incident_histories

  belongs_to :incident_journal,:foreign_key => "journal_id"

  after_save :process_after_save

  def meaning
    return @history_meaning if @history_meaning
    title = I18n.t(("label_icm_incident_request_" + self.property_key.gsub(/\_id$/, "")).to_sym)
    old_meaning = nil
    new_meaning = nil
    old_meaning = I18n.t(:null_string) if self.old_value.nil?||self.old_value.blank?
    new_meaning = I18n.t(:null_string) if self.new_value.nil?||self.new_value.blank?
    case self.property_key
      when "support_person_id"
        if old_meaning.nil?
          real_value = Irm::Person.query_person_name(self.old_value).first
          old_meaning = real_value[:person_name] if real_value
        end
        if new_meaning.nil?
          real_value = Irm::Person.query_person_name(self.new_value).first
          new_meaning = real_value[:person_name] if real_value
        end
      when "support_group_id"
        if old_meaning.nil?
          real_value = Irm::SupportGroup.multilingual_colmun.find(self.old_value)
          old_meaning = real_value[:name] if real_value
        end
        if new_meaning.nil?
          real_value = Irm::SupportGroup.multilingual_colmun.find(self.new_value)
          new_meaning = real_value[:name] if real_value
        end
      when "incident_status_id"
        if old_meaning.nil?
          real_value = Icm::IncidentStatus.multilingual_colmun.query(self.old_value).first
          old_meaning = real_value[:name] if real_value
        end
        if new_meaning.nil?
          real_value = Icm::IncidentStatus.multilingual_colmun.query(self.new_value).first
          new_meaning = real_value[:name] if real_value
        end
      when "close_reason_id"
        if old_meaning.nil?
          real_value = Icm::CloseReason.multilingual_colmun.query(self.old_value).first
          old_meaning = real_value[:name] if real_value
        end
        if new_meaning.nil?
          real_value = Icm::CloseReason.multilingual_colmun.query(self.new_value).first
          new_meaning = real_value[:name] if real_value
        end
    end
    old_meaning = I18n.t(:null_string) if old_meaning.nil?
    new_meaning = I18n.t(:null_string) if new_meaning.nil?
    @history_meaning = {:title=>title,:new_meaning=>new_meaning,:old_meaning=>old_meaning}
    return @history_meaning
  end

  def to_s
    return nil unless ["support_person_id","support_group_id","incident_status_id","close_reason_id"].include?(self.property_key)
    "#{meaning[:title]}: #{meaning[:old_meaning]} ==> #{meaning[:new_meaning]}"
  end


  def process_after_save
    case self.property_key
      when "support_person_id"
        self.incident_journal.incident_request.add_watcher(Irm::Person.find(self.new_value),false) if self.new_value.present?
        Irm::Person.find(self.new_value).update_assign_date
      when "charge_person_id"
        self.incident_journal.incident_request.add_watcher(Irm::Person.find(self.new_value),false) if self.new_value.present?
      when "upgrade_person_id"
        self.incident_journal.incident_request.add_watcher(Irm::Person.find(self.new_value),false) if self.new_value.present?
    end
  end
end
