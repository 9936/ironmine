class MoveAndCleanSysparamData < ActiveRecord::Migration
  def up
            Irm::SystemParameter.all.each do |param|
                system_parameter_id=Irm::SystemParameter.where(:parameter_code=>param[:parameter_code],:opu_id=>"001n00012i8IyyjJakd6Om").first.id

                paramvalue=Irm::SystemParameterValue.new(:opu_id=>param[:opu_id],:system_parameter_id=>system_parameter_id,
                    :value=>param[:value]
                   )

                paramvalue.save(:validate => false)

            end
            Irm::SystemParameter.where("opu_id<>'001n00012i8IyyjJakd6Om'").delete_all
            Irm::SystemParametersTl.where("opu_id<>'001n00012i8IyyjJakd6Om'").delete_all
  end

  def down
  end
end
