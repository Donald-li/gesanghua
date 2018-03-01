class AddUserIdToVisits < ActiveRecord::Migration[5.1]
  def change
    add_column :visits, :user_id, :integer, comment: '用户ID'
  end
end
