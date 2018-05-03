class AddColumnToAccountRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :account_records, :state, :integer, comment: '类型'
  end
end
