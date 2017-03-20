class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts, comment: '用户信息表' do |t|
    	t.string :first_name, limit: 40, default: '', comment: '姓'
    	t.string :last_name, limit: 40, default: '', comment: '名字'
    	t.integer :organization_id
    	t.string :o365_user_id
    	t.string :o365_email, defalut: '', comment: '365邮箱'
    	t.string :job_title
    	t.string :department
    	t.string :mobile, defalut: '', limit: 30, comment: '手机号码'
        t.string :business_phones, default: ''
    	t.string :favorite_color, limit: 20, comment: '喜欢的颜色'
    	t.string :username, limit: 50, comment: '姓名'
    	t.string :password, comment: '密码'
    	t.string :email, limit: 70, comment: '邮箱'
    	t.boolean :remember_me, comment: '是否记住'
        t.integer :role_id, comment: '角色id'
      t.timestamps
    end
  end
end
