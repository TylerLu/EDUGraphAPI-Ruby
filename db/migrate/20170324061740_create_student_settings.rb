class CreateStudentSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :student_settings do |t|
    	t.string :class_id, limit: 40 ,comment: '所在班级id'
    	t.string :user_id, limit: 40, comment: '用户id'
    	t.integer :position, comment: '位置'

      t.timestamps
    end
    add_index :student_settings, [:class_id, :user_id], unique: true
  end
end
