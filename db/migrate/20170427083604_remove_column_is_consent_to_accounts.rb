class RemoveColumnIsConsentToAccounts < ActiveRecord::Migration[5.0]
  def change
    remove_column("accounts", "is_consent")
  end
end
