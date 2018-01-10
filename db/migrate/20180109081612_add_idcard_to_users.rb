class AddIdcardToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :idcard, :string, comment: '身份证'
  end
end
