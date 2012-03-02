# -*- coding: utf-8 -*-
class AddSystemParameterSkmHeader < ActiveRecord::Migration
  def up
    Irm::SystemParameter.where(:content_type=>'SKM_SETTING',:parameter_code=>['SKM_SIDEBAR_NAVI_DISPLAY','SKM_SIDEBAR_FILE_LINK_DISPLAY']).delete_all
    header_audit = Irm::SystemParameter.new(:parameter_code=>'SKM_HEADER_AUDIT',
                                                   :content_type=>'SKM_SETTING',
                                                   :data_type=>'SELECT',

                                                   :status_code=>'ENABLED',
                                                   :not_auto_mult=>true)
    header_audit.system_parameters_tls.build(:system_parameter_id=>header_audit.id,
                                                   :name=>'启用知识审核',
                                                   :description=>'启用知识审核',
                                                   :language=>'zh',
                                                   :status_code=>'ENABLED',
                                                   :source_lang=>'en')
    header_audit.system_parameters_tls.build(:system_parameter_id=>header_audit.id,
                                                   :name=>'Enable Knowledge Audit',
                                                   :description=>'Enable Knowledge Audit',
                                                   :language=>'en',
                                                   :status_code=>'ENABLED',
                                                   :source_lang=>'en')
    header_audit.save
  end

  def down
  end
end
