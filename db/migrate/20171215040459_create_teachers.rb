class CreateTeachers < ActiveRecord::Migration[5.1]
  def change
    create_table :teachers, comment: '老师表' do |t|
      t.string :name, comment: '老师姓名'
      t.string :nickname, comment: '老师昵称'
      t.integer :user_id, comment: '用户ID'
      t.integer :school_id, comment: '学校ID'
      t.integer :kind, comment: '老师类型：1:校长 2:老师', default: 2
      t.string :phone, comment: '老师电话号码'
      t.integer :state, comment: '老师状态: 1:启用 2:禁用', default: 1

      t.timestamps
    end
  end
end
