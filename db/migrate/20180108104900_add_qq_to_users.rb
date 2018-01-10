class AddQqToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :qq, :string, comment: 'qq号'
  end
end
