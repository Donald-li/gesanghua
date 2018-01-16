class AddColumnRecordTimeToTableStatisticRecord < ActiveRecord::Migration[5.1]
  def change
    add_column :statistic_records, :record_time, :datetime, comment: '统计时间'
  end
end
