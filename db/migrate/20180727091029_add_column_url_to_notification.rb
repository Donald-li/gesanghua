class AddColumnUrlToNotification < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :url, :string
  end
end
