class AddManagerIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :manager_id, :integer, comment: '线下用户管理人id'
  end
end
