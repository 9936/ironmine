class AddCuxToHotlineProject < ActiveRecord::Migration
  def change
    opu = Irm::OperationUnit.where("short_name = ?", "Hand").first.id

    systems = Irm::ExternalSystem.
        where("external_system_code IN (?)", ['10538',
        '10539',
        '10541',
        '10544',
        '2',
        '10062',
        '10064',
        '10288',
        '10366',
        '10370',
        '10419',
        '10488',
        '10497',
        '10503',
        '10508',
        '10004',
        '10445',
        '10067',
        '10410',
        '10423',
        '10422',
        '10493',
        '10115',
        '10122',
        '10487',
        '10140',
        '10145',
        '10405',
        '10478',
        '10479',
        '10155',
        '10161',
        '10171',
        '10414',
        '10489',
        '10228',
        '10441',
        '10247',
        '10494',
        '10373',
        '10382',
        '10383',
        '10387',
        '10506',
        '10499',
        '10500',
        '10501',
        '10507',
        '10512',
        '10513',
        '10517',
        '10520',
        '10522',
        '10524',
        '10529',
        '10526',
        '10528',
        '10531',
        '10533',
        '10537'])

    systems.each do |sys|
      t1 = Irm::ObjectAttributeSystem.
          where(:object_attribute_id, "001k00040nKEhszG5xnOrI").
          where(:external_system_id, sys.id)
      t2 = Irm::ObjectAttributeSystem.
          where(:object_attribute_id, "001k00040nKEhszG4ocrtg").
          where(:external_system_id, sys.id)
      Irm::ObjectAttributeSystem.create(:opu_id => opu,
                                        :object_attribute_id => "001k00040nKEhszG5xnOrI",
                                        :external_system_id => sys.id,
                                        :display_sequence => 1) unless t1.any?
      Irm::ObjectAttributeSystem.create(:opu_id => opu,
                                        :object_attribute_id => "001k00040nKEhszG4ocrtg",
                                        :external_system_id => sys.id,
                                        :display_sequence => 2) unless t2.any?
    end
  end
end
