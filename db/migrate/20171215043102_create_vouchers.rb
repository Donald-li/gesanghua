class CreateVouchers < ActiveRecord::Migration[5.1]
  def change
    create_table :vouchers, comment: '捐助收据表' do |t|
      t.integer :user_id, comment: '用户ID'
      t.decimal :amount, precision: 14, scale: 2, default: 0.0, comment: '金额'
      t.integer :state, comment: '状态'
      t.string :contact_name, comment: '联系人姓名'
      t.string :contact_phone, comment: '联系人电话'
      t.string :province, comment: '省'
      t.string :city, comment: '市'
      t.string :district, comment: '区/县'
      t.string :address, comment: '详细地址'

      t.timestamps
    end
  end
end
