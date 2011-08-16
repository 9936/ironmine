# -*- coding: utf-8 -*-
class ModifySkmColumnName < ActiveRecord::Migration
  def self.up
    function = Irm::Function.where(:code => "SKM_COLUMN")
    if function.any?
      function.first.functions_tls.each do |f|
        if f.language == "zh"
          f.update_attribute(:name, "管理知识库分类")
          f.update_attribute(:description, "管理知识库分类")
        elsif f.language == "en"
          f.update_attribute(:name, "Manage SKM Categories")
          f.update_attribute(:description, "Manage SKM Categories")
        end
      end
    end

    function_group = Irm::FunctionGroup.where(:code => "SKM_COLUMN")
    if function_group.any?
      function_group.first.function_groups_tls.each do |f|
        if f.language == "zh"
          f.update_attribute(:name, "知识库分类")
          f.update_attribute(:description, "知识库分类")
        elsif f.language == "en"
          f.update_attribute(:name, "SKM Category")
          f.update_attribute(:description, "SKM Category")
        end
      end
    end
  end

  def self.down
  end
end
