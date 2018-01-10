class AddUserIdToSchools < ActiveRecord::Migration[5.1]
  def change
    add_column :schools, :user_id, :integer, comment: '用户id'
  end
end
