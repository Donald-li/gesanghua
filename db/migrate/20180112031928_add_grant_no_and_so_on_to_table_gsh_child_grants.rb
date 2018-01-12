class AddGrantNoAndSoOnToTableGshChildGrants < ActiveRecord::Migration[5.1]
  def change
    add_column :gsh_child_grants, :grant_no, :string, comment: '格桑花发放编号'
    add_column :gsh_child_grants, :granted_at, :datetime, comment: '发放时间'
    add_column :gsh_child_grants, :grant_remark, :text, comment: '发放说明'
    add_column :gsh_child_grants, :delay_reason, :string, comment: '暂缓发放原因'
    add_column :gsh_child_grants, :delay_remark, :text, comment: '暂缓发放备注'
    add_column :gsh_child_grants, :cancel_reason, :string, comment: '取消原因'
    add_column :gsh_child_grants, :balance_manage, :integer, comment: '取消余额处理'
    add_column :gsh_child_grants, :cancel_remark, :text, comment: '取消说明'
  end
end
