class CreateCrossFundAdjustments < ActiveRecord::Migration[5.1]
  def change
    create_table :cross_fund_adjustments do |t|
      t.integer :kind, comment: '类型：1:平台 2:配捐 3:退款'
      t.integer :from_fund_id, comment: '被调整分类'
      t.integer :to_fund_id, comment: '调整到分类'
      t.decimal :amount, precision: 14, scale: 2, default: "0", comment: '调整金额'

      t.timestamps
    end
  end
end
