class AddColumnPasswordDigestToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :password_digest, :string
  end
end
