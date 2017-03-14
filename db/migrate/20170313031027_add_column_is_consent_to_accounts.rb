class AddColumnIsConsentToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :is_consent, :boolean, comment: '是否授权'
  end
end
