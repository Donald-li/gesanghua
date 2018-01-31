class AddUserIdToFeedback < ActiveRecord::Migration[5.1]
  def change
    add_column :feedbacks, :user_id, :integer, comment: '反馈人'
  end
end
