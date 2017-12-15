class CreateChildren < ActiveRecord::Migration[5.1]
  def change
    create_table :children, comment: '格桑花孩子表' do |t|
      t.string :idcard, comment: '身份证'
      t.string :name, comment: '姓名'
      t.integer :school_id, comment: '学校ID'
      t.integer :user_id, comment: '用户ID'
      t.string :password_digest, comment: '密码'
      t.string :gsh_no, comment: '格桑花内部编码'
      t.integer :state, comment: '状态：1:启用 2:禁用', default: 1

      t.timestamps
    end
  end
end
