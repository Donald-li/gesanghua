class AddColumnKindToTaskVolunteer < ActiveRecord::Migration[5.1]
  def change
    add_column :task_volunteers, :kind, :integer, comment: '类型'
  end
end
