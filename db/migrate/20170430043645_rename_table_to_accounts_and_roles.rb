class RenameTableToAccountsAndRoles < ActiveRecord::Migration[5.0]
  def change
    rename_table("accounts_and_roles", "user_roles")
  end
end
