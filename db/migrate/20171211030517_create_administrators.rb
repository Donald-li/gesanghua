class CreateAdministrators < ActiveRecord::Migration[5.1]
  def change
    create_table :administrators, comment: '管理员' do |t|
      t.string :login, comment: '登录名'
      t.string :nickname, comment: '昵称'
      t.string :password_digest, comment: '密码'
      t.datetime :expire_at, comment: '过期时间', default: Date.new(2099, 12, 31)
      t.integer :state, comment: '状态 1:正常 2:禁用', default: 1
      t.integer :kind, :integer, default: 2, comment: '管理员类型 1:超级管理员 2:普通管理员'

      t.timestamps
    end
  end
end
