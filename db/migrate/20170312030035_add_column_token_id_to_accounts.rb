class AddColumnTokenIdToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :token_id, :integer
  end
end
