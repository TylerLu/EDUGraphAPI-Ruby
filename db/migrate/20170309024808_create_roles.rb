class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles, comment: '用户角色表' do |t|
    	t.string :role_name, limit: 30, comment: '角色名称'

      t.timestamps
    end
  end
end
