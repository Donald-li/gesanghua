class CreateExpenditureLedgers < ActiveRecord::Migration[5.1]
  def change
    create_table :expenditure_ledgers, comment: '支出分类' do |t|
      t.string :name, comment: '名称'
      t.integer :position, comment: '排序'
      t.decimal :amount, precision: 14, scale: 2, default: 0.0, comment: '合计支出金额'
      t.text :describe, comment: '描述'
      t.integer :state, comment: '状态'

      t.timestamps
    end
  end
end
