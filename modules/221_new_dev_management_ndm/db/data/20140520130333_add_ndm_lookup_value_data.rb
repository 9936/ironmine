# encoding: utf-8
class AddNdmLookupValueData < ActiveRecord::Migration
  def up
    #priority
    lv = Irm::LookupValue.new(:lookup_type=>'NDM_PRIORITY',:lookup_code=>'NDM_PRIORITY_HIGH',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'High',:description=>'High',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'High',:description=>'High',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'NDM_PRIORITY',:lookup_code=>'NDM_PRIORITY_MIDDLE',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Middle',:description=>'Middle',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Middle',:description=>'Middle',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'NDM_PRIORITY',:lookup_code=>'NDM_PRIORITY_LOW',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Low',:description=>'Low',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Low',:description=>'Low',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    #type
    #Apex, HTML/TSV, SVF, Interface, Java, Program, Personalization
    lv = Irm::LookupValue.new(:lookup_type=>'NDM_TYPE',:lookup_code=>'NDM_TYPE_APEX',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Apex',:description=>'Apex',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Apex',:description=>'Apex',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'NDM_TYPE',:lookup_code=>'NDM_TYPE_HTML',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'HTML/TSV',:description=>'HTML/TSV',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'HTML/TSV',:description=>'HTML/TSV',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'NDM_TYPE',:lookup_code=>'NDM_TYPE_SVF',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'SVF',:description=>'SVF',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'SVF',:description=>'SVF',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'NDM_TYPE',:lookup_code=>'NDM_TYPE_INTERFACE',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Interface',:description=>'Interface',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Interface',:description=>'Interface',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'NDM_TYPE',:lookup_code=>'NDM_TYPE_JAVA',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Java',:description=>'Java',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Java',:description=>'Java',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'NDM_TYPE',:lookup_code=>'NDM_TYPE_PROGRAM',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Program',:description=>'Program',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Program',:description=>'Program',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'NDM_TYPE',:lookup_code=>'NDM_TYPE_PERSON',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Personalization',:description=>'Personalization',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Personalization',:description=>'Personalization',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    #NDM_METHOD
    #New, Update
    lv = Irm::LookupValue.new(:lookup_type=>'NDM_METHOD',:lookup_code=>'NDM_METHOD_NEW',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'New',:description=>'New',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'New',:description=>'New',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'NDM_METHOD',:lookup_code=>'NDM_METHOD_UPDATE',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Update',:description=>'Update',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Update',:description=>'Update',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    #NDM_DIFFICULTY
    #Very Easy, Easy, Medium, Complex, Maintain
    lv = Irm::LookupValue.new(:lookup_type=>'NDM_DIFFICULTY',:lookup_code=>'NDM_DIFFICULTY_VEASY',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Very Easy',:description=>'Very Easy',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Very Easy',:description=>'Very Easy',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'NDM_DIFFICULTY',:lookup_code=>'NDM_DIFFICULTY_EASY',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Easy',:description=>'Easy',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Easy',:description=>'Easy',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'NDM_DIFFICULTY',:lookup_code=>'NDM_DIFFICULTY_MEDIUM',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Medium',:description=>'Medium',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Medium',:description=>'Medium',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'NDM_DIFFICULTY',:lookup_code=>'NDM_DIFFICULTY_COMPLEX',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Complex',:description=>'Complex',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Complex',:description=>'Complex',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'NDM_DIFFICULTY',:lookup_code=>'NDM_DIFFICULTY_MAINTAIN',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Maintain',:description=>'Maintain',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Maintain',:description=>'Maintain',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    #NDM_PHASE_STATUS
    #Open, In process, Completed, Cancelled, Delayed
    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'NDM_PHASE_STATUS',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Phase Status',:description=>'Phase Status',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Phase Status',:description=>'Phase Status',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save

    lv = Irm::LookupValue.new(:lookup_type=>'NDM_PHASE_STATUS',:lookup_code=>'NDM_PHASE_STATUS_OPEN',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Open',:description=>'Open',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Open',:description=>'Open',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'NDM_PHASE_STATUS',:lookup_code=>'NDM_PHASE_STATUS_IP',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'In process',:description=>'In process',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'In process',:description=>'In process',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'NDM_PHASE_STATUS',:lookup_code=>'NDM_PHASE_STATUS_COMPLETED',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Completed',:description=>'Completed',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Completed',:description=>'Completed',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'NDM_PHASE_STATUS',:lookup_code=>'NDM_PHASE_STATUS_CANCELLED',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Cancelled',:description=>'Cancelled',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Cancelled',:description=>'Cancelled',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'NDM_PHASE_STATUS',:lookup_code=>'NDM_PHASE_STATUS_DELAYED',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Delayed',:description=>'Delayed',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Delayed',:description=>'Delayed',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

  end

  def down
  end
end
