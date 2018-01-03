class AddSomeColumnsToVolunteerAndUser < ActiveRecord::Migration[5.1]
  def change
    add_column :volunteers, :kind, :integer, comment: '类型'
    add_column :volunteers, :approve_state, :integer, comment: '认证状态'
    add_column :volunteers, :approve_time, :datetime, comment: '认证时间'
  end
end
