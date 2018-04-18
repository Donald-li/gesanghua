class CreateAmountTabs < ActiveRecord::Migration[5.1]
  def change
    create_table :amount_tabs, comment: '金额选项卡表' do |t|
      t.decimal :amount, precision: 14, scale: 2, default: 0.0, comment: '金额'
      t.string :alias, comment: '别名'
      t.integer :state, default: 1, comment: '状态 1:显示 2:隐藏'
      t.integer :donate_item_id, comment: '可捐助id'
      t.timestamps
    end
  end
end
