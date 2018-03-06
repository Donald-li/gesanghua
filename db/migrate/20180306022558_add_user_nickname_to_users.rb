class AddUserNicknameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :use_nickname, :integer, comment: '使用昵称'

  end
end
