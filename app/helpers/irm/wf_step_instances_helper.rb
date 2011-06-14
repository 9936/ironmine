module Irm::WfStepInstancesHelper
  def step_instance_approvable_fields(wf_process_instance)
    process = wf_process_instance.wf_approval_process
    fields = process.approve_fields.split(",").delete_if{|i| !i.strip.present?}
    approvable_fields = Array.new(fields.length)
    wf_process_instance.business_object.approval_attributes.each do |oa|
      index = fields.index(oa.attribute_name)
      if index
        approvable_fields[index] = oa
      end
    end
    approvable_fields.compact
  end
end
