class AddSomeSolumnToVolunteers < ActiveRecord::Migration[5.1]
  def change
    add_column :volunteers, :wechat, :string
    add_column :volunteers, :qq, :string
    add_column :volunteers, :email, :string
  end
end
