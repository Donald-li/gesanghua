class AddRecordTypeToDonateRecord < ActiveRecord::Migration[5.1]
  def change
    add_column :donate_records, :kind, :integer, comment: '记录类型: 1:系统生成 2:手动添加'
  end
end
