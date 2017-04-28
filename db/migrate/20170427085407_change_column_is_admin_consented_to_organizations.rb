class ChangeColumnIsAdminConsentedToOrganizations < ActiveRecord::Migration[5.0]
  def change
    change_column :organizations, :is_admin_consented, :boolean
  end
end
