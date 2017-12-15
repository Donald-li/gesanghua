class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, comment: '用户' do |t|
      t.string :openid, comment: '微信openid'
      t.string :name, comment: '姓名'
      t.string :login, comment: '登录账号'
      t.string :password_digest, comment: '密码'
      t.integer :state, comment: '状态，0：禁用 1：启用',default: 1
      t.integer :team_id, comment: '团队ID'
      t.jsonb :profile, comment: '微信profile'
      t.integer :gender, comment: '性别，1：男 2：女'
      t.decimal :balance, precision: 14, scale: 2, default: "0.0", comment: '账户余额'
      t.string :phone, comment: '联系方式'

      t.timestamps
    end
  end
end
