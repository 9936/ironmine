# -*- coding:utf-8 -*-
class AddMamLookup < ActiveRecord::Migration
  def up
    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'MAM_ITEM_CATEGORY',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_ITEM_CATEGORY',:description=>'MAM_ITEM_CATEGORY',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_ITEM_CATEGORY',:description=>'MAM_ITEM_CATEGORY',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_ITEM_CATEGORY',:lookup_code=>'NEW',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'New',:description=>'New',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'New',:description=>'New',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_ITEM_CATEGORY',:lookup_code=>'ASSIGN_ORG',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Assign Org',:description=>'Assign Org',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Assign Org',:description=>'Assign Org',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'MAM_SNG',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_SNG',:description=>'MAM_SNG',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_SNG',:description=>'MAM_SNG',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SNG',:lookup_code=>'NO_CONTROL',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'No Control',:description=>'No Control',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'No Control',:description=>'No Control',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SNG',:lookup_code=>'AT_RECEIPT',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'At Receipt',:description=>'At Receipt',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'At Receipt',:description=>'At Receipt',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SNG',:lookup_code=>'AT_SALES_ORDER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'At Sales Order Issue',:description=>'At Sales Order Issue',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'At Sales Order Issue',:description=>'At Sales Order Issue',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SNG',:lookup_code=>'PREDEFINED',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Predefind',:description=>'Predefind',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Predefind',:description=>'Predefind',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'MAM_TEMPLATE',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_TEMPLATE',:description=>'MAM_TEMPLATE',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_TEMPLATE',:description=>'MAM_TEMPLATE',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'1100',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Product',:description=>'Product',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Product',:description=>'Product',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'1110',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Product : Stock To Order(PO)',:description=>'Product : Stock To Order(PO)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Product : Stock To Order(PO)',:description=>'Product : Stock To Order(PO)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'1200',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Product : Model Bom Product(MFG)',:description=>'Product : Model Bom Product(MFG)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Product : Model Bom Product(MFG)',:description=>'Product : Model Bom Product(MFG)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'1210',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Product : Model Bom Product(PO)',:description=>'Product : Model Bom Product(PO)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Product : Model Bom Product(PO)',:description=>'Product : Model Bom Product(PO)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'1300',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Product : MFG to Order(ATO/MTO/ETO)',:description=>'Product : MFG to Order(ATO/MTO/ETO)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Product : MFG to Order(ATO/MTO/ETO)',:description=>'Product : MFG to Order(ATO/MTO/ETO)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'1310',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Product : PO to Order(ATO/MTO/ETO)',:description=>'Product : PO to Order(ATO/MTO/ETO)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Product : PO to Order(ATO/MTO/ETO)',:description=>'Product : PO to Order(ATO/MTO/ETO)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'1400',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Purchase from other supplier   ',:description=>'Purchase from other supplier   ',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Purchase from other supplier   ',:description=>'Purchase from other supplier   ',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'1500',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Service',:description=>'Service',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Service',:description=>'Service',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'1600',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Product : Kit',:description=>'Product : Kit',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Product : Kit',:description=>'Product : Kit',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'1610',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Product : Kit for Local',:description=>'Product : Kit for Local',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Product : Kit for Local',:description=>'Product : Kit for Local',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'1900',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Used Item',:description=>'Used Item',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Used Item',:description=>'Used Item',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'2100',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Parts/Raw Material',:description=>'Parts/Raw Material',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Parts/Raw Material',:description=>'Parts/Raw Material',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'2200',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Processing Goods',:description=>'Processing Goods',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Processing Goods',:description=>'Processing Goods',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'2210',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Outside Goods',:description=>'Outside Goods',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Outside Goods',:description=>'Outside Goods',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'2300',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Indirect Materials',:description=>'Indirect Materials',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Indirect Materials',:description=>'Indirect Materials',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'2310',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Indirect Expence',:description=>'Indirect Expence',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Indirect Expence',:description=>'Indirect Expence',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'2320',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Container',:description=>'Container',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Container',:description=>'Container',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'2400',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Engineering Item',:description=>'Engineering Item',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Engineering Item',:description=>'Engineering Item',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'3000',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'D-Code',:description=>'D-Code',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'D-Code',:description=>'D-Code',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'3100',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Option Class',:description=>'Option Class',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Option Class',:description=>'Option Class',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'9100',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Prototype',:description=>'Prototype',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Prototype',:description=>'Prototype',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_TEMPLATE',:lookup_code=>'9200',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Prototype of  D-Code',:description=>'Prototype of  D-Code',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Prototype of  D-Code',:description=>'Prototype of  D-Code',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'MAM_SC_CATEGORY',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_SC_CATEGORY',:description=>'MAM_SC_CATEGORY',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_SC_CATEGORY',:description=>'MAM_SC_CATEGORY',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_CATEGORY',:lookup_code=>'NEW',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'New',:description=>'New',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'New',:description=>'New',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_CATEGORY',:lookup_code=>'UPDATE',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Update',:description=>'Update',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Update',:description=>'Update',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'MAM_SC_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_SC_TYPE',:description=>'MAM_SC_TYPE',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_SC_TYPE',:description=>'MAM_SC_TYPE',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_TYPE',:lookup_code=>'CU',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Customer',:description=>'Customer',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Customer',:description=>'Customer',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_TYPE',:lookup_code=>'ES',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Employee supplier',:description=>'Employee supplier',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Employee supplier',:description=>'Employee supplier',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_TYPE',:lookup_code=>'FC',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Finance company',:description=>'Finance company',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Finance company',:description=>'Finance company',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_TYPE',:lookup_code=>'NS',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Non-trade supplier',:description=>'Non-trade supplier',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Non-trade supplier',:description=>'Non-trade supplier',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_TYPE',:lookup_code=>'TS',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Trade supplier',:description=>'Trade supplier',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Trade supplier',:description=>'Trade supplier',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_TYPE',:lookup_code=>'TA',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Tax authority',:description=>'Tax authority',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Tax authority',:description=>'Tax authority',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_TYPE',:lookup_code=>'YG',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Yanmar Group',:description=>'Yanmar Group',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Yanmar Group',:description=>'Yanmar Group',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_TYPE',:lookup_code=>'OT',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Others',:description=>'Others',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Others',:description=>'Others',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'MAM_SC_ACCOUNT_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_SC_ACCOUNT_TYPE',:description=>'MAM_SC_ACCOUNT_TYPE',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_SC_ACCOUNT_TYPE',:description=>'MAM_SC_ACCOUNT_TYPE',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_ACCOUNT_TYPE',:lookup_code=>'EXTERNAL',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'External',:description=>'External',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'External',:description=>'External',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_ACCOUNT_TYPE',:lookup_code=>'INTERNAL',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Internal',:description=>'Internal',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Internal',:description=>'Internal',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'MAM_SC_CLASSIFICATION',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_SC_CLASSIFICATION',:description=>'MAM_SC_CLASSIFICATION',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_SC_CLASSIFICATION',:description=>'MAM_SC_CLASSIFICATION',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_CLASSIFICATION',:lookup_code=>'BMS',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Billed Material Supplier',:description=>'Billed Material Supplier',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Billed Material Supplier',:description=>'Billed Material Supplier',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_CLASSIFICATION',:lookup_code=>'DDOEM',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Dealer/Distributor/OEM',:description=>'Dealer/Distributor/OEM',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Dealer/Distributor/OEM',:description=>'Dealer/Distributor/OEM',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_CLASSIFICATION',:lookup_code=>'YG',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'YANMAR Group',:description=>'YANMAR Group',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'YANMAR Group',:description=>'YANMAR Group',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_CLASSIFICATION',:lookup_code=>'OT',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Others',:description=>'Others',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Others',:description=>'Others',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'MAM_SC_CURRENCY',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_SC_CURRENCY',:description=>'MAM_SC_CURRENCY',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_SC_CURRENCY',:description=>'MAM_SC_CURRENCY',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_CURRENCY',:lookup_code=>'CAD',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'CAD',:description=>'CAD',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'CAD',:description=>'CAD',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_CURRENCY',:lookup_code=>'CNY',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'CNY',:description=>'CNY',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'CNY',:description=>'CNY',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_CURRENCY',:lookup_code=>'EUR',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'EUR',:description=>'EUR',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'EUR',:description=>'EUR',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_CURRENCY',:lookup_code=>'GBP',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'GBP',:description=>'GBP',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'GBP',:description=>'GBP',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_CURRENCY',:lookup_code=>'IDR',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'IDR',:description=>'IDR',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'IDR',:description=>'IDR',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_CURRENCY',:lookup_code=>'JPY',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'JPY',:description=>'JPY',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'JPY',:description=>'JPY',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_CURRENCY',:lookup_code=>'SEK',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'SEK',:description=>'SEK',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'SEK',:description=>'SEK',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_CURRENCY',:lookup_code=>'SGD',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'SGD',:description=>'SGD',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'SGD',:description=>'SGD',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_CURRENCY',:lookup_code=>'THB',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'THB',:description=>'THB',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'THB',:description=>'THB',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_SC_CURRENCY',:lookup_code=>'USD',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'USD',:description=>'USD',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'USD',:description=>'USD',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_UR_CATEGORY',:lookup_code=>'NEW',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'New',:description=>'New',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'New',:description=>'New',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_UR_CATEGORY',:lookup_code=>'UPDATE',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Update',:description=>'Update',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Update',:description=>'Update',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'MAM_UR_STATUS',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_UR_STATUS',:description=>'MAM_UR_STATUS',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_UR_STATUS',:description=>'MAM_UR_STATUS',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_UR_STATUS',:lookup_code=>'ACTIVE',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Active',:description=>'Active',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Active',:description=>'Active',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_UR_STATUS',:lookup_code=>'INACTIVE',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Inactive',:description=>'Inactive',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Inactive',:description=>'Inactive',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'MAM_UR_ACTION',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_UR_ACTION',:description=>'MAM_UR_ACTION',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_UR_ACTION',:description=>'MAM_UR_ACTION',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_UR_ACTION',:lookup_code=>'ADD',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Add',:description=>'Add',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Add',:description=>'Add',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_UR_ACTION',:lookup_code=>'DELETE',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Delete',:description=>'Delete',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Delete',:description=>'Delete',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_UR_ACTION',:lookup_code=>'ADJUST',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Adjust',:description=>'Adjust',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Adjust',:description=>'Adjust',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

  end

  def down
  end
end
