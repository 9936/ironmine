# -*- coding: utf-8 -*-
class AddSkmColumnsLovData < ActiveRecord::Migration
  def self.up
    skm_column = Irm::ListOfValue.new(:lov_code => "SKM_COLUMNS", :bo_code => "SKM_COLUMNS_VL",
                                      :where_clause => "{{master_table}}.status_code='ENABLED'",
                                      :query_clause => "", :id_column => "id", :value_column => "name",
                                      :value_column_width => "80", :desc_column =>"description",
                                      :desc_column_width => "120", :listable_flag => "N",:not_auto_mult=>true)
    skm_column.skm_columns_tls.build(:language=>'zh',:source_lang=>'en',:name=>'知识库栏目',:description=>'知识库栏目',
                                     :value_title => "栏目名", :desc_title => "描述")
    skm_column.skm_columns_tls.build(:language=>'en',:source_lang=>'en',:name=>'Skm Columns',:description=>'Skm Columns',
                                     :value_title => "Column Name", :desc_title => "Description")
  end

  def self.down
  end
end
