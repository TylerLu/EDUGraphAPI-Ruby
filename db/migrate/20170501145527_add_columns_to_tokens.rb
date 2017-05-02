class AddColumnsToTokens < ActiveRecord::Migration[5.0]
  def change
    add_column :tokens, :o365_userId, :string
    add_column :tokens, :refresh_token, :string
    add_column :tokens, :access_tokens, :string
  end
end
