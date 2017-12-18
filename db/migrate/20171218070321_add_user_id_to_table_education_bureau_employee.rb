class AddUserIdToTableEducationBureauEmployee < ActiveRecord::Migration[5.1]
  def change
    add_column :education_bureau_employees, :user_id, :integer, comment: '用户ID'
  end
end
