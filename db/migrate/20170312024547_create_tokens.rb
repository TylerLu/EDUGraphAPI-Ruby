class CreateTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :tokens, comment: "用户token表" do |t|
      t.string :gwn_refresh_token, limit: 2000, comment: '用户graph window net 的 refresh token'
      t.string :o365email, limit: 50, comment: '用户的office 365邮箱'
      t.string :gmc_refresh_token, limit: 2000, comment: '用户的graph microsoft refresh token'

      t.timestamps
    end
  end
end
