class CreateFunds < ActiveRecord::Migration[5.1]
  def change
    create_table :funds do |t|
      t.string :name, comment: '基金名'
      t.integer :position, comment: '排序'
      t.decimal :amount, precision: 14, scale: 2, default: 0.0, comment: '金额'
      t.decimal :total, precision: 14, scale: 2, default: '0.0', comment: '历史收入'
      t.integer :management_rate, default: 0, comment: '管理费率'
      t.string :describe, comment: '简介'
      t.integer :state, default: 1, comment: '状态 1:显示 2:隐藏'
      t.belongs_to :fund_category, index: true

      t.timestamps
    end
  end
end
