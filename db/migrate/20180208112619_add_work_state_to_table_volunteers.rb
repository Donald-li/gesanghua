class AddWorkStateToTableVolunteers < ActiveRecord::Migration[5.1]
  def change
    add_column :volunteers, :work_state, :integer, comment: '实习还是正式'
  end
end
