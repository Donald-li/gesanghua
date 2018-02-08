class AddKindAndPhoneVerifyToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :kind, :integer, default: 2, comment: '用户类型 1:平台用户 2:线上用户 3:线下用户'
    add_column :users, :phone_verify, :integer, default: 1, comment: '手机认证 1:未认证 2:已认证'
  end
end
