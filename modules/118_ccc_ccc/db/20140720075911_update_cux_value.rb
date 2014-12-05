class UpdateCuxValue < ActiveRecord::Migration
  def up
    requests = Icm::IncidentRequest.where("1=1")
    requests.each do |re|
      #move cux field value
      cux_fields = execute(%Q(SELECT mcfs.field_id '0', mcfs.bug_id '1', mcfs.value '2', ioa.attribute_name '3' FROM mantis_custom_field_string_table mcfs, irm_object_attributes ioa
                              WHERE mcfs.bug_id = '#{re.request_number}' AND mcfs.field_id = ioa.data_extra_info AND ioa.external_system_id = '#{re.external_system_id}'))
      puts("++++++++++++++++++++++++++++++++++++++++++++ moving cux field: " + re.request_number)
      puts("++++++++++++++++++++++++++++++++++++++++++++ moving cux field: " + cux_fields.to_json)
      cux_fields.each do |cf|
        re.update_attribute(cf[3].to_sym, cf[2].to_s)
        puts("++++++++++++++++++++++++++++++++++++++++++++ updating cux field: #{cf[3]} - #{cf[2]}")
      end
    end

  end

  def down
  end
end
