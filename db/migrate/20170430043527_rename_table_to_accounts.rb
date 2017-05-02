class RenameTableToAccounts < ActiveRecord::Migration[5.0]
  def change
    rename_table("accounts", "users")
  end
end
