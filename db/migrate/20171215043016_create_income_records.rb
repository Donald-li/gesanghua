class CreateIncomeRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :income_records, comment: '入帐记录表' do |t|
      t.integer :user_id, comment: '用户id'
      t.integer :finance_category_id, comment: '财务分类id'
      t.string :appoint_type, comment: '指定类型'
      t.integer :appoint_id, comment: '指定类型id'
      t.integer :state, comment: '状态'
      t.integer :income_source_id, comment: '来源id'
      t.decimal :amount, precision: 14, scale: 2, default: "0.0", comment: '入账金额'
      t.decimal :balance, precision: 14, scale: 2, default: "0.0", comment: '余额'
      t.string :remitter_name, comment: '汇款人姓名'
      t.integer :remitter_id, comment: '汇款人id'
      t.string :donor, comment: '捐赠者'
      t.integer :promoter_id, comment: '劝捐人'
      t.integer :donate_record_id, comment: '捐助记录id'

      t.timestamps
    end
  end
end
