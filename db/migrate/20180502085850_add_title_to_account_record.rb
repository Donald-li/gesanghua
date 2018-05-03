class AddTitleToAccountRecord < ActiveRecord::Migration[5.1]
  def change
    add_column :account_records, :title, :string, comment: '标题'
  end
end
