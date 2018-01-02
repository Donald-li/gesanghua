class AddNicknameAndSalutationToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :nickname, :string, comment: '昵称'
    add_column :users, :salutation, :string, comment: '孩子们如何称呼我'
    add_column :users, :consignee, :string, comment: '收货人'
    add_column :users, :province, :string, comment: '省'
    add_column :users, :city, :string, comment: '市'
    add_column :users, :district, :string, comment: '区/县'
    add_column :users, :address, :string, comment: '详细地址'
  end
end
