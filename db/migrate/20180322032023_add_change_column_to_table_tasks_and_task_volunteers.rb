class AddChangeColumnToTableTasksAndTaskVolunteers < ActiveRecord::Migration[5.1]
  def change
    remove_column :task_volunteers, :finish_state, :integer
    remove_column :task_volunteers, :approve_state, :integer
    add_column :task_volunteers, :state, :integer
  end
end
