class RemoveColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :role_id
    remove_column :users, :unlink_email
  end
end
