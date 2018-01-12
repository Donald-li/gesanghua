class CreateChildPeriods < ActiveRecord::Migration[5.1]
  def change
    create_table :child_periods, comment: '孩子捐助学期表' do |t|
      t.integer :grant_id, comment: '发放记录ID'
      t.integer :project_season_id, comment: '项目年度ID'
      t.integer :gsh_child_id, comment: '格桑花孩子ID'
      t.integer :donate_record_id, comment: '捐助记录ID'
      t.integer :user_id, comment: '捐赠人ID'
      t.string :name, comment: '名称'
      t.text :description, comment: '描述'
      t.integer :state, comment: '状态'
      t.decimal :amount, precision: 14, scale: 2, default: "0.0", comment: "资助金额"

      t.timestamps
    end
  end
end
