class CreateStatisticRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :statistic_records do |t|
      t.integer :amount, precision: 14, scale: 2, default: "0", comment: '今日更新数量'
      t.integer :kind, comment: '类型'

      t.timestamps
    end
  end
end
