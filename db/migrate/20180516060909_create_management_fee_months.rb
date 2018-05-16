class CreateManagementFeeMonths < ActiveRecord::Migration[5.1]
  def change
    create_table :management_fee_months, comment: '管理费提取' do |t|
      t.string :month, comment: '月份'
      t.integer :count, default: 0, comment: '项目数'
      t.decimal :fee, precision: 14, scale: 2, default: 0.0, comment: '管理费'
      t.integer :state, comment: '状态'

      t.timestamps
    end

    add_column :management_fees, :month_id, :integer, comment: '月份'
  end
end
