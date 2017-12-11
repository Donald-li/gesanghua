class CreateAdministratorLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :administrator_logs, comment: '管理员日志' do |t|
      t.integer :administrator_id, comment: '管理员id'
      t.integer :kind, comment: '日志动作类型，1:登录 2:登出'
      t.string :ip, comment: 'ip地址'

      t.timestamps
    end
  end
end
