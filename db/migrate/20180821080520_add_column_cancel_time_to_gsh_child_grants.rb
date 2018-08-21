class AddColumnCancelTimeToGshChildGrants < ActiveRecord::Migration[5.1]
  def change
    add_column :gsh_child_grants, :cancel_time, :datetime, comment: '异常操作时间'
  end
end
