class CreateMonthDonateRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :month_donate_records, comment: '月捐记录表' do |t|
      t.integer :month_donate_id, comment: '月捐id'
      t.decimal :amount, precision: 14, scale: 2, default: "0.0", comment: '每期捐助金额'
      t.integer :period, comment: '期数'

      t.timestamps
    end
  end
end
