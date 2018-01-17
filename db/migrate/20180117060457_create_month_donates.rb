class CreateMonthDonates < ActiveRecord::Migration[5.1]
  def change
    create_table :month_donates, comment: '月捐表' do |t|
      t.integer :user_id, comment: '用户id'
      t.integer :fund_id, comment: '基金id'
      t.integer :plan_period, comment: '计划期数'
      t.integer :donated_period, comment: '已捐期数'
      t.decimal :amount, precision: 14, scale: 2, default: "0.0", comment: '每期捐助金额'
      t.datetime :start_time, comment: '开始时间'
      t.integer :state, comment: '捐助状态 1:捐助中 2:已结束'
      t.timestamps
    end
  end
end
