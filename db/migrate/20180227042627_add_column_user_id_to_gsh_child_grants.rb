class AddColumnUserIdToGshChildGrants < ActiveRecord::Migration[5.1]
  def change
    add_column :gsh_child_grants, :user_id, :integer, comment: '捐助人'
  end
end
