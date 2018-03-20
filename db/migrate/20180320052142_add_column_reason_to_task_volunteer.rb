class AddColumnReasonToTaskVolunteer < ActiveRecord::Migration[5.1]
  def change
    add_column :task_volunteers, :reason, :text, comment: '申请理由'
  end
end
