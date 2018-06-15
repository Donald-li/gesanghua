class AddColumnActivedAtToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :actived_at, :datetime, comment: '激活时间'
  end
end
