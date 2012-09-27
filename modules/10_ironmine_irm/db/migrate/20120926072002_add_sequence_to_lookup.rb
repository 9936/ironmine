class AddSequenceToLookup < ActiveRecord::Migration
  def up
    add_column :irm_lookup_values, "sequence", :integer,:default => 1,:after=>:status_code
    add_column :irm_lookup_values, "values", :string,:default => '',:after=>:sequence

    #默认为原有的lookup设置sequence
    lookup_types = Irm::LookupType.all
    lookup_types.each do |type|
      #根据lookup_type值进行查找lookup_values
      lookup_values = Irm::LookupValue.where(:lookup_type => type.lookup_type)
      sequence = 0
      lookup_values.each do |value|
        sequence += 1
        value.sequence = sequence
        value.not_auto_mult = true
        value.save!
      end if lookup_values.any?
    end if lookup_types.any?
  end

  def down
    remove_column :irm_lookup_values, "sequence"
    remove_column :irm_lookup_values, "values"
  end
end
