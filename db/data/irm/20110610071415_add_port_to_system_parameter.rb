# -*- coding:utf-8 -*-
class AddPortToSystemParameter < ActiveRecord::Migration
  def self.up
    host_port = Irm::SystemParameter.new(:parameter_code=>'HOST_PORT',
                                               :content_type=>'GLOBAL_SETTING',
                                               :data_type=>'TEXT',
                                               :value => "3000",
                                               :status_code=>'ENABLED',
                                               :not_auto_mult=>true)
    host_port.system_parameters_tls.build(:system_parameter_id=>host_port.id,
                                               :name=>'主机端口',
                                               :description=>'主机端口',
                                               :language=>'zh',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    host_port.system_parameters_tls.build(:system_parameter_id=>host_port.id,
                                               :name=>'Host port',
                                               :description=>'Host port',
                                               :language=>'en',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    host_port.save
  end

  def self.down
  end
end
