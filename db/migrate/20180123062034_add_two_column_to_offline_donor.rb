class AddTwoColumnToOfflineDonor < ActiveRecord::Migration[5.1]
  def change
    add_column :offline_donors, :nickname, :string, comment: '昵称'
    add_column :offline_donors, :salutation, :string, comment: '孩子们如何称呼我'
  end
end
