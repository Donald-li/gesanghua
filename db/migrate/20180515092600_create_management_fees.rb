class CreateManagementFees < ActiveRecord::Migration[5.1]
  def change
    create_table :management_fees, comment: '管理费' do |t|
      t.string :owner_type, comment: '所属项目'
      t.integer :owner_id, comment: '所属项目ID'
      t.decimal :total_amount, precision: 14, scale: 2, default: 0.0, comment: '项目金额'
      t.decimal :amount, precision: 14, scale: 2, default: 0.0, comment: '提取管理费金额'
      t.integer :fund_id, comment: '收入分类'
      t.float :rate, precision: 4, scale: 2, comment: '费率'
      t.decimal :fee, precision: 14, scale: 2, default: 0.0, comment: '管理费金额'
      t.integer :user_id, comment: '用户'
      t.integer :state, comment: '状态'

      t.timestamps
    end
  end
end
