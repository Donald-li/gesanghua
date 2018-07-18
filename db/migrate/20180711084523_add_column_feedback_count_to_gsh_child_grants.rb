class AddColumnFeedbackCountToGshChildGrants < ActiveRecord::Migration[5.1]
  def change
    add_column :gsh_child_grants, :feedback_count, :integer
  end
end
