# -*- coding: utf-8 -*-
class AddErrorPageConfigToSystemParameter < ActiveRecord::Migration
  def up
    opu_2 = Irm::OperationUnit.where("short_name = ?", "Hand").first
    #opu_2
    error_404 = Irm::SystemParameter.new(:parameter_code=>'ERROR_404',:opu_id => opu_2.id,
                                               :content_type=>'GLOBAL_SETTING',
                                               :data_type=>'TEXT',
                                               :value => "",
                                               :status_code=>'ENABLED',
                                               :not_auto_mult=>true)
    error_404.system_parameters_tls.build(:system_parameter_id=>error_404.id,:opu_id => opu_2.id,
                                               :name=>'错误404页面信息',
                                               :description=>'错误404页面信息',
                                               :language=>'zh',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    error_404.system_parameters_tls.build(:system_parameter_id=>error_404.id,:opu_id => opu_2.id,
                                               :name=>'Error 404 info',
                                               :description=>'Error 404 info',
                                               :language=>'en',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    error_404.save


    error_500 = Irm::SystemParameter.new(:parameter_code=>'ERROR_500',
                                               :content_type=>'GLOBAL_SETTING',:opu_id => opu_2.id,
                                               :data_type=>'TEXT',
                                               :value => "",
                                               :status_code=>'ENABLED',
                                               :not_auto_mult=>true)
    error_500.system_parameters_tls.build(:system_parameter_id=>error_500.id,:opu_id => opu_2.id,
                                               :name=>'错误500页面信息',
                                               :description=>'错误500页面信息',
                                               :language=>'zh',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    error_500.system_parameters_tls.build(:system_parameter_id=>error_500.id,:opu_id => opu_2.id,
                                               :name=>'Error 500 info',
                                               :description=>'Error 500 info',
                                               :language=>'en',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    error_500.save

    error_422 = Irm::SystemParameter.new(:parameter_code=>'ERROR_422',:opu_id => opu_2.id,
                                               :content_type=>'GLOBAL_SETTING',
                                               :data_type=>'TEXT',
                                               :value => "",
                                               :status_code=>'ENABLED',
                                               :not_auto_mult=>true)
    error_422.system_parameters_tls.build(:system_parameter_id=>error_422.id,:opu_id => opu_2.id,
                                               :name=>'错误422页面信息',
                                               :description=>'错误422页面信息',
                                               :language=>'zh',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    error_422.system_parameters_tls.build(:system_parameter_id=>error_422.id,:opu_id => opu_2.id,
                                               :name=>'Error 422 info',
                                               :description=>'Error 422 info',
                                               :language=>'en',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    error_422.save

    error_access_deny = Irm::SystemParameter.new(:parameter_code=>'ERROR_ACCESS_DENY',:opu_id => opu_2.id,
                                               :content_type=>'GLOBAL_SETTING',
                                               :data_type=>'TEXT',
                                               :value => "",
                                               :status_code=>'ENABLED',
                                               :not_auto_mult=>true)
    error_access_deny.system_parameters_tls.build(:system_parameter_id=>error_access_deny.id,:opu_id => opu_2.id,
                                               :name=>'错误Access Deny页面信息',
                                               :description=>'错误Access Deny页面信息',
                                               :language=>'zh',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    error_access_deny.system_parameters_tls.build(:system_parameter_id=>error_access_deny.id,:opu_id => opu_2.id,
                                               :name=>'Error Access Deny info',
                                               :description=>'Error Access Deny info',
                                               :language=>'en',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    error_access_deny.save
  end

  def down

  end
end
