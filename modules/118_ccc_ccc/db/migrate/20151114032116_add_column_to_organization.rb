class AddColumnToOrganization < ActiveRecord::Migration
  def change

    add_column :irm_organizations, :industry_id, :string

  end
end
