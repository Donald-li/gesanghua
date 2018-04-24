class AddCancelReasonToGshChildGrants < ActiveRecord::Migration[5.1]
  def change
    remove_column :gsh_child_grants, :cancel_reason, :string
    add_column :gsh_child_grants, :cancel_reason, :integer, comment: '取消原因'
  end
end
