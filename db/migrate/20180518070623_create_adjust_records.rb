class CreateAdjustRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :adjust_records, comment: '分类调整记录' do |t|
      t.integer :from_fund_id, comment: '从哪个分类'
      t.integer :to_fund_id, comment: '调到哪个分类'
      t.decimal :amount, precision: 14, scale: 2, default: 0.0, comment: '金额'
      t.integer :user_id, comment: '操作人'

      t.timestamps
    end
  end
end
