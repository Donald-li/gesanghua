class AddColumnsToDonateRecords < ActiveRecord::Migration[5.1]
  def change
    drop_table :month_donate_records, comment: '删除月捐记录表'

    add_column :donate_records, :period, :integer, comment: '月捐期数'
    add_column :donate_records, :month_donate_id, :integer, comment: '月捐id'
  end
end
