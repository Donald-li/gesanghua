class CreateExpenditureRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :expenditure_records, comment: '支出记录表' do |t|
      t.integer :finance_category_id, comment: '财务分类id'
      t.string :appoint_type, comment: '指定类型'
      t.integer :appoint_id, comment: '指定类型id'
      t.integer :administrator_id, comment: '管理员id'
      t.integer :income_record_id, comment: '入账记录id'
      t.integer :deliver_state, comment: '发放状态'
      t.integer :kind, comment: '类别'

      t.timestamps
    end
  end
end
