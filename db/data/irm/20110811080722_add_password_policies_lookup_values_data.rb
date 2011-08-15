# -*- coding: utf-8 -*-
class AddPasswordPoliciesLookupValuesData < ActiveRecord::Migration
  def self.up
    irm_psw_expire_in=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_PSW_EXPIRE_IN',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_expire_in.lookup_types_tls.build(:lookup_type_id=>irm_psw_expire_in.id,:meaning=>'用户密码有效期',:description=>'用户密码有效期',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in.lookup_types_tls.build(:lookup_type_id=>irm_psw_expire_in.id,:meaning=>'User Password Expire Days',:description=>'User Password Expire Days',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in.save
    irm_psw_enforce_history=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history.lookup_types_tls.build(:lookup_type_id=>irm_psw_enforce_history.id,:meaning=>'强制密码历史',:description=>'强制密码历史',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history.lookup_types_tls.build(:lookup_type_id=>irm_psw_enforce_history.id,:meaning=>'Enforce Password History',:description=>'Enforce Password History',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history.save
    irm_psw_minimum_length=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_PSW_MINIMUM_LENGTH',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_minimum_length.lookup_types_tls.build(:lookup_type_id=>irm_psw_minimum_length.id,:meaning=>'密码最小长度',:description=>'密码最小长度',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_minimum_length.lookup_types_tls.build(:lookup_type_id=>irm_psw_minimum_length.id,:meaning=>'Minimum Password Length',:description=>'Minimum Password Length',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_minimum_length.save
    irm_psw_complexity_req=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_PSW_COMPLEXITY_REQ',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_complexity_req.lookup_types_tls.build(:lookup_type_id=>irm_psw_complexity_req.id,:meaning=>'密码复杂性要求',:description=>'密码复杂性要求',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_complexity_req.lookup_types_tls.build(:lookup_type_id=>irm_psw_complexity_req.id,:meaning=>'Password Complexity Requirement',:description=>'Password Complexity Requirement',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_complexity_req.save
    irm_psw_question_req=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_PSW_QUESTION_REQ',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_question_req.lookup_types_tls.build(:lookup_type_id=>irm_psw_question_req.id,:meaning=>'密码提问要求',:description=>'密码提问要求',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_question_req.lookup_types_tls.build(:lookup_type_id=>irm_psw_question_req.id,:meaning=>'Password Question Requirement',:description=>'Password Question Requirement',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_question_req.save
    irm_psw_maximum_attempts=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_PSW_MAXIMUM_ATTEMPTS',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_maximum_attempts.lookup_types_tls.build(:lookup_type_id=>irm_psw_maximum_attempts.id,:meaning=>'最大无效登陆尝试次数',:description=>'最大无效登陆尝试次数',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_maximum_attempts.lookup_types_tls.build(:lookup_type_id=>irm_psw_maximum_attempts.id,:meaning=>'Maximum Invalid Login Attempts',:description=>'Maximum Invalid Login Attempts',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_maximum_attempts.save
    irm_psw_lockout_period=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_PSW_LOCKOUT_PERIOD',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_lockout_period.lookup_types_tls.build(:lookup_type_id=>irm_psw_lockout_period.id,:meaning=>'锁定有效期间',:description=>'锁定有效期间',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_lockout_period.lookup_types_tls.build(:lookup_type_id=>irm_psw_lockout_period.id,:meaning=>'Lockout Effective Period',:description=>'Lockout Effective Period',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_lockout_period.save

    irm_psw_expire_in30= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_EXPIRE_IN',:lookup_code=>'30',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_expire_in30.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in30.id,:meaning=>'30天',:description=>'30天',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in30.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in30.id,:meaning=>'30 Days',:description=>'30 Days',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in30.save
    irm_psw_expire_in60= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_EXPIRE_IN',:lookup_code=>'60',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_expire_in60.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in60.id,:meaning=>'60天',:description=>'60天',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in60.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in60.id,:meaning=>'60 Days',:description=>'60 Days',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in60.save
    irm_psw_expire_in90= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_EXPIRE_IN',:lookup_code=>'90',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_expire_in90.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in90.id,:meaning=>'90天',:description=>'90天',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in90.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in90.id,:meaning=>'90 Days',:description=>'90 Days',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in90.save
    irm_psw_expire_in180= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_EXPIRE_IN',:lookup_code=>'180',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_expire_in180.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in180.id,:meaning=>'180天',:description=>'180天',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in180.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in180.id,:meaning=>'180 Days',:description=>'180 Days',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in180.save
    irm_psw_expire_in365= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_EXPIRE_IN',:lookup_code=>'365',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_expire_in365.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in365.id,:meaning=>'一年',:description=>'一年',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in365.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in365.id,:meaning=>'One Years',:description=>'One Years',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in365.save
    irm_psw_expire_in0= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_EXPIRE_IN',:lookup_code=>'0',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_expire_in0.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in0.id,:meaning=>'永不到期',:description=>'永不到期',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in0.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in0.id,:meaning=>'Never expires',:description=>'Never expires',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in0.save
    irm_psw_enforce_history1= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'1',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history1.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history1.id,:meaning=>'记住1个密码',:description=>'记住1个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history1.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history1.id,:meaning=>'1 password remembered',:description=>'1 password remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history1.save
    irm_psw_enforce_history2= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'2',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history2.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history2.id,:meaning=>'记住2个密码',:description=>'记住2个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history2.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history2.id,:meaning=>'2 passwords remembered',:description=>'2 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history2.save
    irm_psw_enforce_history3= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'3',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history3.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history3.id,:meaning=>'记住3个密码',:description=>'记住3个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history3.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history3.id,:meaning=>'3 passwords remembered',:description=>'3 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history3.save
    irm_psw_enforce_history4= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'4',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history4.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history4.id,:meaning=>'记住4个密码',:description=>'记住4个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history4.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history4.id,:meaning=>'4 passwords remembered',:description=>'4 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history4.save
    irm_psw_enforce_history5= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'5',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history5.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history5.id,:meaning=>'记住5个密码',:description=>'记住5个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history5.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history5.id,:meaning=>'5 passwords remembered',:description=>'5 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history5.save
    irm_psw_enforce_history6= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'6',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history6.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history6.id,:meaning=>'记住6个密码',:description=>'记住6个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history6.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history6.id,:meaning=>'6 passwords remembered',:description=>'6 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history6.save
    irm_psw_enforce_history7= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'7',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history7.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history7.id,:meaning=>'记住7个密码',:description=>'记住7个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history7.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history7.id,:meaning=>'7 passwords remembered',:description=>'7 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history7.save
    irm_psw_enforce_history8= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'8',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history8.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history8.id,:meaning=>'记住8个密码',:description=>'记住8个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history8.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history8.id,:meaning=>'8 passwords remembered',:description=>'8 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history8.save
    irm_psw_enforce_history9= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'9',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history9.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history9.id,:meaning=>'记住9个密码',:description=>'记住9个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history9.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history9.id,:meaning=>'9 passwords remembered',:description=>'9 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history9.save
    irm_psw_enforce_history10= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'10',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history10.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history10.id,:meaning=>'记住10个密码',:description=>'记住10个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history10.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history10.id,:meaning=>'10 passwords remembered',:description=>'10 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history10.save
    irm_psw_enforce_history11= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'11',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history11.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history11.id,:meaning=>'记住11个密码',:description=>'记住11个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history11.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history11.id,:meaning=>'11 passwords remembered',:description=>'11 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history11.save
    irm_psw_enforce_history12= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'12',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history12.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history12.id,:meaning=>'记住12个密码',:description=>'记住12个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history12.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history12.id,:meaning=>'12 passwords remembered',:description=>'12 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history12.save
    irm_psw_enforce_history13= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'13',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history13.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history13.id,:meaning=>'记住13个密码',:description=>'记住13个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history13.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history13.id,:meaning=>'13 passwords remembered',:description=>'13 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history13.save
    irm_psw_enforce_history14= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'14',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history14.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history14.id,:meaning=>'记住14个密码',:description=>'记住14个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history14.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history14.id,:meaning=>'14 passwords remembered',:description=>'14 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history14.save
    irm_psw_enforce_history15= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'15',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history15.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history15.id,:meaning=>'记住15个密码',:description=>'记住15个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history15.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history15.id,:meaning=>'15 passwords remembered',:description=>'15 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history15.save
    irm_psw_enforce_history0= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'0',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history0.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history0.id,:meaning=>'未记住任何密码',:description=>'未记住任何密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history0.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history0.id,:meaning=>'No passwords remembered',:description=>'No passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history0.save
    irm_psw_minimum_length5= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_MINIMUM_LENGTH',:lookup_code=>'5',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_minimum_length5.lookup_values_tls.build(:lookup_value_id=>irm_psw_minimum_length5.id,:meaning=>'5个字符',:description=>'5个字符',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_minimum_length5.lookup_values_tls.build(:lookup_value_id=>irm_psw_minimum_length5.id,:meaning=>'5 characters',:description=>'5 characters',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_minimum_length5.save
    irm_psw_minimum_length8= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_MINIMUM_LENGTH',:lookup_code=>'8',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_minimum_length8.lookup_values_tls.build(:lookup_value_id=>irm_psw_minimum_length8.id,:meaning=>'8个字符',:description=>'8个字符',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_minimum_length8.lookup_values_tls.build(:lookup_value_id=>irm_psw_minimum_length8.id,:meaning=>'8 characters',:description=>'8 characters',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_minimum_length8.save
    irm_psw_minimum_length10= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_MINIMUM_LENGTH',:lookup_code=>'10',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_minimum_length10.lookup_values_tls.build(:lookup_value_id=>irm_psw_minimum_length10.id,:meaning=>'10个字符',:description=>'10个字符',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_minimum_length10.lookup_values_tls.build(:lookup_value_id=>irm_psw_minimum_length10.id,:meaning=>'10 characters',:description=>'10 characters',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_minimum_length10.save
    irm_psw_complexity_req0= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_COMPLEXITY_REQ',:lookup_code=>'0',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_complexity_req0.lookup_values_tls.build(:lookup_value_id=>irm_psw_complexity_req0.id,:meaning=>'无限制',:description=>'无限制',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_complexity_req0.lookup_values_tls.build(:lookup_value_id=>irm_psw_complexity_req0.id,:meaning=>'No restriction',:description=>'No restriction',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_complexity_req0.save
    irm_psw_complexity_req1= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_COMPLEXITY_REQ',:lookup_code=>'1',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_complexity_req1.lookup_values_tls.build(:lookup_value_id=>irm_psw_complexity_req1.id,:meaning=>'必须混合使用字母和数字',:description=>'必须混合使用字母和数字',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_complexity_req1.lookup_values_tls.build(:lookup_value_id=>irm_psw_complexity_req1.id,:meaning=>'Must mix alpha and numeric',:description=>'Must mix alpha and numeric',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_complexity_req1.save
    irm_psw_question_req0= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_QUESTION_REQ',:lookup_code=>'0',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_question_req0.lookup_values_tls.build(:lookup_value_id=>irm_psw_question_req0.id,:meaning=>'无',:description=>'无',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_question_req0.lookup_values_tls.build(:lookup_value_id=>irm_psw_question_req0.id,:meaning=>'None',:description=>'None',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_question_req0.save
    irm_psw_question_req1= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_QUESTION_REQ',:lookup_code=>'1',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_question_req1.lookup_values_tls.build(:lookup_value_id=>irm_psw_question_req1.id,:meaning=>'不能包含密码',:description=>'不能包含密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_question_req1.lookup_values_tls.build(:lookup_value_id=>irm_psw_question_req1.id,:meaning=>'Cannot contain password',:description=>'Cannot contain password',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_question_req1.save
    irm_psw_maximum_attempts3= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_MAXIMUM_ATTEMPTS',:lookup_code=>'3',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_maximum_attempts3.lookup_values_tls.build(:lookup_value_id=>irm_psw_maximum_attempts3.id,:meaning=>'3',:description=>'3',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_maximum_attempts3.lookup_values_tls.build(:lookup_value_id=>irm_psw_maximum_attempts3.id,:meaning=>'3',:description=>'3',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_maximum_attempts3.save
    irm_psw_maximum_attempts5= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_MAXIMUM_ATTEMPTS',:lookup_code=>'5',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_maximum_attempts5.lookup_values_tls.build(:lookup_value_id=>irm_psw_maximum_attempts5.id,:meaning=>'5',:description=>'5',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_maximum_attempts5.lookup_values_tls.build(:lookup_value_id=>irm_psw_maximum_attempts5.id,:meaning=>'5',:description=>'5',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_maximum_attempts5.save
    irm_psw_maximum_attempts10= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_MAXIMUM_ATTEMPTS',:lookup_code=>'10',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_maximum_attempts10.lookup_values_tls.build(:lookup_value_id=>irm_psw_maximum_attempts10.id,:meaning=>'10',:description=>'10',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_maximum_attempts10.lookup_values_tls.build(:lookup_value_id=>irm_psw_maximum_attempts10.id,:meaning=>'10',:description=>'10',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_maximum_attempts10.save
    irm_psw_maximum_attempts0= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_MAXIMUM_ATTEMPTS',:lookup_code=>'0',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_maximum_attempts0.lookup_values_tls.build(:lookup_value_id=>irm_psw_maximum_attempts0.id,:meaning=>'无限制',:description=>'无限制',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_maximum_attempts0.lookup_values_tls.build(:lookup_value_id=>irm_psw_maximum_attempts0.id,:meaning=>'No limit',:description=>'No limit',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_maximum_attempts0.save
    irm_psw_lockout_period15= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_LOCKOUT_PERIOD',:lookup_code=>'15',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_lockout_period15.lookup_values_tls.build(:lookup_value_id=>irm_psw_lockout_period15.id,:meaning=>'15 分钟',:description=>'15 分钟',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_lockout_period15.lookup_values_tls.build(:lookup_value_id=>irm_psw_lockout_period15.id,:meaning=>'15 minutes',:description=>'15 minutes',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_lockout_period15.save
    irm_psw_lockout_period30= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_LOCKOUT_PERIOD',:lookup_code=>'30',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_lockout_period30.lookup_values_tls.build(:lookup_value_id=>irm_psw_lockout_period30.id,:meaning=>'30 分钟',:description=>'30 分钟',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_lockout_period30.lookup_values_tls.build(:lookup_value_id=>irm_psw_lockout_period30.id,:meaning=>'30 minutes',:description=>'30 minutes',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_lockout_period30.save
    irm_psw_lockout_period60= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_LOCKOUT_PERIOD',:lookup_code=>'60',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_lockout_period60.lookup_values_tls.build(:lookup_value_id=>irm_psw_lockout_period60.id,:meaning=>'60 分钟',:description=>'60 分钟',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_lockout_period60.lookup_values_tls.build(:lookup_value_id=>irm_psw_lockout_period60.id,:meaning=>'60 minutes',:description=>'60 minutes',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_lockout_period60.save
    irm_psw_lockout_period0= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_LOCKOUT_PERIOD',:lookup_code=>'0',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_lockout_period0.lookup_values_tls.build(:lookup_value_id=>irm_psw_lockout_period0.id,:meaning=>'始终(必须从管理员重置)',:description=>'始终(必须从管理员重置)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_lockout_period0.lookup_values_tls.build(:lookup_value_id=>irm_psw_lockout_period0.id,:meaning=>'Forever (must be reset by admin)',:description=>'Forever (must be reset by admin)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_lockout_period0.save
  end

  def self.down
  end
end
