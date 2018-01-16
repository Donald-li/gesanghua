class CreateGshChildren < ActiveRecord::Migration[5.1]
  def change
    create_table :gsh_children, comment: '格桑花孩子表' do |t|
      t.integer :school_id, comment: '关联学校id'
      t.string :name, comment: '孩子姓名'
      t.string :province, comment: '省'
      t.string :city, comment: '市'
      t.string :district, comment: '区/县'
      t.string :gsh_no, comment: '格桑花孩子编号'
      t.string :phone, comment: '联系电话'
      t.string :qq, comment: 'qq号'
      t.integer :user_id, comment: '关联用户id'

      t.timestamps
    end
  end
end
