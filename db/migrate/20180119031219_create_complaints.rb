class CreateComplaints < ActiveRecord::Migration[5.1]
  def change
    create_table :complaints, comment: '举报表' do |t|
      t.string :contact_name, comment: '联系人姓名'
      t.string :contact_phone, comment: '联系人手机'
      t.text :content, comment: '举报详情'
      t.string :owner_type
      t.integer :owner_id
      t.integer :state, comment: '处理状态： 1:submit 2:check'
      t.text :remark, comment: '处理备注'

      t.timestamps
    end
  end
end
