# -*- coding: utf-8 -*-
class RefactorWikiFunction < ActiveRecord::Migration
  def up
    lv = Irm::LookupValue.where(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'IRM_WIKI').first
    if lv
      lv.destroy
    end



    fg = Irm::FunctionGroup.where(:code=>'IRM_WIKI').first
    if fg
      fg.destroy
    end

    f1 =Irm::Function.where(:code=>'VIEW_WIKI').first
    if f1
      f1.destroy
    end

    f2 = Irm::Function.where(:code=>'CREATE_WIKI').first
    if f2
      f2.destroy
    end
    f3 = Irm::Function.where(:code=>'EDIT_WIKI').first
    if f3
      f3.destroy
    end
    f4 = Irm::Function.where(:code=>'MANAGE_WIKI').first
    if f4
      f4.destroy
    end

    skm_skm_wiki= Irm::FunctionGroup.new(:zone_code=>'KNOWLEDGE_MANAGEMENT',:code=>'SKM_WIKI',:controller=>'skm/wikis',:action=>'index',:not_auto_mult=>true)
    skm_skm_wiki.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'Wiki',:description=>'Wiki')
    skm_skm_wiki.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Wiki',:description=>'Wiki')
    skm_skm_wiki.save
    skm_view_wiki= Irm::Function.new(:function_group_code=>'SKM_WIKI',:code=>'VIEW_WIKI',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    skm_view_wiki.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看Wiki',:description=>'查看Wiki')
    skm_view_wiki.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View Wiki',:description=>'View Wiki')
    skm_view_wiki.save
    skm_create_wiki= Irm::Function.new(:function_group_code=>'SKM_WIKI',:code=>'CREATE_WIKI',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    skm_create_wiki.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'新建Wiki',:description=>'新建Wiki')
    skm_create_wiki.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Create Wiki',:description=>'Create Wiki')
    skm_create_wiki.save
    skm_edit_wiki= Irm::Function.new(:function_group_code=>'SKM_WIKI',:code=>'EDIT_WIKI',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    skm_edit_wiki.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑Wiki',:description=>'编辑Wiki')
    skm_edit_wiki.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'New Wiki',:description=>'New Wiki')
    skm_edit_wiki.save
    skm_manage_wiki= Irm::Function.new(:function_group_code=>'SKM_WIKI',:code=>'MANAGE_WIKI',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    skm_manage_wiki.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理Wiki',:description=>'管理Wiki')
    skm_manage_wiki.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Wiki',:description=>'Manage Wiki')
    skm_manage_wiki.save
  end

  def down
  end
end
