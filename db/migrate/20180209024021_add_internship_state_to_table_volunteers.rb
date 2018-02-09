class AddInternshipStateToTableVolunteers < ActiveRecord::Migration[5.1]
  def change
    remove_column :volunteers, :work_state
    add_column :volunteers, :internship_state, :integer, comment: '实习还是正式'
  end
end
