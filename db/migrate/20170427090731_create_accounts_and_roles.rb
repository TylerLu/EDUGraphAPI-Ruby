class CreateAccountsAndRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts_and_roles do |t|
      t.integer :account_id, index: true
      t.integer :role_id, index: true

      t.timestamps
    end
  end
end
