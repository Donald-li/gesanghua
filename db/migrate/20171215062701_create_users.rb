class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, comment: '用户' do |t|
      t.string :openid, comment: '微信openid'
      t.string :name, comment: '姓名'
      t.string :login, comment: '登录账号', index: true
      t.string :password_digest, comment: '密码'
      t.integer :state, comment: '状态 1:启用 2:禁用', default: 1
      t.integer :team_id, comment: '团队ID'
      t.jsonb :profile, comment: '微信profile'
      t.integer :gender, comment: '性别，1：男 2：女'
      t.decimal :balance, precision: 14, scale: 2, default: 0.0, comment: '账户余额'
      t.string :phone, comment: '联系方式', index: true
      t.string :email, comment: '电子邮箱地址', index: true

      t.timestamps
    end
  end
end
