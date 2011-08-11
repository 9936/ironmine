class Irm::BulletinColumn < ActiveRecord::Base
  set_table_name :irm_bulletin_columns

  belongs_to :bulletin
  belongs_to :bu_column
end