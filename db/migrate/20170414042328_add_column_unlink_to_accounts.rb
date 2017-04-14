class AddColumnUnlinkToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :unlink_email, :string, default: '', comment: '用于判断是否unlink'
  end
end
