# -*- coding: utf-8 -*-
class ModifySkmTranslation < ActiveRecord::Migration
  def up
    Irm::MenuEntriesTl.where(:name => "知识库状态").each do |t|
      t.update_attributes(:name => "知识状态", :description => "知识状态")
    end

    Irm::MenuEntriesTl.where(:name => "知识库模板").each do |t|
      t.update_attributes(:name => "知识模板", :description => "知识模板")
    end

    Irm::MenuEntriesTl.where(:name => "知识库模板元素").each do |t|
      t.update_attributes(:name => "知识模板元素", :description => "知识模板元素")
    end

    Irm::MenuEntriesTl.where(:name => "知识库分类").each do |t|
      t.update_attributes(:name => "知识分类", :description => "知识分类")
    end

    Irm::MenuEntriesTl.where(:name => "知识库频道").each do |t|
      t.update_attributes(:name => "知识频道", :description => "知识频道")
    end

    Irm::MenuEntriesTl.where(:name => "外部系统").each do |t|
      t.update_attributes(:name => "应用系统", :description => "应用系统")
    end

    Irm::MenuEntriesTl.where(:name => "外部系统成员").each do |t|
      t.update_attributes(:name => "应用系统成员", :description => "应用系统成员")
    end

    Irm::MenusTl.where(:name => "外部系统").each do |t|
      t.update_attributes(:name => "应用系统", :description => "应用系统")
    end

    Irm::FunctionsTl.where(:name => "管理知识库状态").each do |t|
      t.update_attributes(:name => "管理知识状态", :description => "管理知识状态")
    end

    Irm::FunctionsTl.where(:name => "管理知识库模板").each do |t|
      t.update_attributes(:name => "管理知识模板", :description => "管理知识模板")
    end

    Irm::FunctionsTl.where(:name => "管理知识库模板元素").each do |t|
      t.update_attributes(:name => "管理知识模板元素", :description => "管理知识模板元素")
    end

    Irm::FunctionsTl.where(:name => "管理知识库分类").each do |t|
      t.update_attributes(:name => "管理知识分类", :description => "管理知识分类")
    end

    Irm::FunctionsTl.where(:name => "管理知识库频道").each do |t|
      t.update_attributes(:name => "管理知识频道", :description => "管理知识频道")
    end

    Irm::FunctionsTl.where(:name => "编辑知识库频道").each do |t|
      t.update_attributes(:name => "编辑知识频道", :description => "编辑知识频道")
    end

    Irm::FunctionsTl.where(:name => "管理外部系统").each do |t|
      t.update_attributes(:name => "管理应用系统", :description => "管理应用系统")
    end

    Irm::FunctionsTl.where(:name => "管理外部系统成员").each do |t|
      t.update_attributes(:name => "管理应用系统成员", :description => "管理应用系统成员")
    end

    Irm::FunctionGroupsTl.where(:name => "外部系统").each do |t|
      t.update_attributes(:name => "应用系统", :description => "应用系统")
    end

    Irm::FunctionGroupsTl.where(:name => "外部系统成员").each do |t|
      t.update_attributes(:name => "应用系统成员", :description => "应用系统成员")
    end
  end

  def down
  end
end
