class AddColumnWechatToTeachers < ActiveRecord::Migration[5.1]
  def change
    add_column :teachers, :wechat, :string, comment: '微信'
  end
end
