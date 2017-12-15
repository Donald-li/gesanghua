class CreateOfflineDonors < ActiveRecord::Migration[5.1]
  def change
    create_table :offline_donors, comment: '代捐人表' do |t|
      t.integer :user_id, comment: '用户ID'
      t.string :name, comment: '姓名'
      t.integer :state, comment: '状态'
      t.integer :gender, comment: '性别，1：男 2：女'
      t.string :email, comment: '邮箱'
      t.string :phone, comment: '联系方式'
      t.string :address, comment: '详细地址'

      t.timestamps
    end
  end
end
