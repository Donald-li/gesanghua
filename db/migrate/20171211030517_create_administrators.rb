class CreateAdministrators < ActiveRecord::Migration[5.1]
  def change
    create_table :administrators, comment: '管理员' do |t|
      t.string :nickname, comment: '昵称'
      t.datetime :expire_at, comment: '过期时间', default: Date.new(2099, 12, 31)
      t.integer :state, comment: '状态 1:正常 2:禁用', default: 1
      t.belongs_to :user, index: true
      t.integer :kind, :integer, default: 2, comment: '管理员类型 1:超级管理员 2:系统管理员 3:项目管理员 4:财务人员'

      t.timestamps
    end
  end
end
