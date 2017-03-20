class CreateOrganizations < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations, comment: '组织表' do |t|
      t.string :tenant_id, limit: 80, comment: '租户id'
      t.string :name, limit: 30, comment: '组织名'
      t.string :is_admin_consented, limit: 1, comment: '是否被admin授权'

      t.timestamps
    end
  end
end
