class AddBoardFunction < ActiveRecord::Migration
  def up
    csi_csi_survey= Irm::FunctionGroup.new(:zone_code=>'BOC_BOARD',:code=>'BOC_BOARD',:controller=>'boc/boards',:action=>'index',:not_auto_mult=>true)
    csi_csi_survey.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'Board',:description=>'Board')
    csi_csi_survey.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Board',:description=>'Board')
    csi_csi_survey.save

    boc_bulletin_board= Irm::Function.new(:function_group_code=>'HOME_PAGE',:code=>'BULLETIN_BOARD',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    boc_bulletin_board.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'Board',:description=>'Board')
    boc_bulletin_board.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Board',:description=>'Board')
    boc_bulletin_board.save


    boc_function_group_board= Irm::LookupValue.new(:lookup_type=>'BOC_FUNCTION_GROUP_ZONE',:lookup_code=>'BOARD',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    boc_function_group_board.lookup_values_tls.build(:lookup_value_id=>boc_function_group_board.id,:meaning=>'Board',:description=>'Board',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    boc_function_group_board.lookup_values_tls.build(:lookup_value_id=>boc_function_group_board.id,:meaning=>'Board',:description=>'Board',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    boc_function_group_board.save
  end

  def down
  end
end
