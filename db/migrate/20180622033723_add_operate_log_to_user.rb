class AddOperateLogToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :operate_log, :jsonb, comment: '危险操作记录：用户合并、指定代捐管理人、代捐人激活'
  end
end
