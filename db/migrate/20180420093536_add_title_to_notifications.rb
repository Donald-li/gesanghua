class AddTitleToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :title, :string, comment: '消息标题'
  end
end
