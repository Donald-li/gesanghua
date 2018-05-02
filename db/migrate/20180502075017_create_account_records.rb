class CreateAccountRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :account_records, comment: '账户记录' do |t|
      t.integer :user_id, comment: '用户ID'
      t.integer :kind, comment: '操作类型'
      t.integer :income_record_id
      t.integer :donate_record_id
      t.integer :donor_id
      t.decimal :amount, precision: 14, scale: 2, default: 0.0, comment: '金额'
      t.text :remark, comment: '备注'

      t.timestamps
    end
  end
end
