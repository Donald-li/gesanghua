class AddColumnUserIdToComplaints < ActiveRecord::Migration[5.1]
  def change
    add_column :complaints, :user_id, :integer
  end
end
