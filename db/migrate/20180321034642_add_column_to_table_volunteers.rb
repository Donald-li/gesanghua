class AddColumnToTableVolunteers < ActiveRecord::Migration[5.1]
  def change
    add_column :volunteers, :leave_reason, :jsonb, comment: '请假原因[类型, 说明]'
  end
end
