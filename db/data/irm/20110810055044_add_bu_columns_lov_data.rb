# -*- coding: utf-8 -*-
class AddBuColumnsLovData < ActiveRecord::Migration
  def self.up
    bu_column = Irm::ListOfValue.new(:lov_code => "BULLETIN_COLUMNS", :bo_code => "IRM_BU_COLUMNS_VL",
                                      :where_clause => "{{master_table}}.status_code='ENABLED'",
                                      :query_clause => "", :id_column => "id", :value_column => "name",
                                      :value_column_width => "80", :desc_column =>"description",
                                      :desc_column_width => "120", :listable_flag => "N",:not_auto_mult=>true)
    bu_column.list_of_values_tls.build(:language=>'zh',:source_lang=>'en',:name=>'公告栏目',:description=>'公告栏目',
                                     :value_title => "栏目名", :desc_title => "描述")
    bu_column.list_of_values_tls.build(:language=>'en',:source_lang=>'en',:name=>'Bulletin Columns',:description=>'Bulletin Columns',
                                     :value_title => "Column Name", :desc_title => "Description")

    bu_column.save
  end

  def self.down
  end
end
