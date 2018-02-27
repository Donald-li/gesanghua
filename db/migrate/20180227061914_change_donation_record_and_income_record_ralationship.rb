class ChangeDonationRecordAndIncomeRecordRalationship < ActiveRecord::Migration[5.1]
  def change
    add_column :donate_records, :income_record_id, :integer, comment: '收入记录'
    remove_column :income_records, :donate_record_id, :integer, comment: '捐助记录'
  end
end
