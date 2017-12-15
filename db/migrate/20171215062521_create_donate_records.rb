class CreateDonateRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :donate_records, comment: '捐赠记录' do |t|
      t.integer :user_id, comment: '用户id'      
      t.string :appoint_type, comment: '指定类型'      
      t.integer :appoint_id, comment: '指定类型'      
      t.integer :finance_category_id, comment: '类别id'      
      t.integer :pay_state, comment: '状态'      
      t.decimal :amount, precision: 14, scale: 2, default: "0.0", comment: '任务id'      
      t.integer :project_id, comment: '项目id'      
      t.integer :project_apply_id, comment: '项目申请id'
      t.integer :team_id, comment: '小组id'
      t.string :message, comment: '汇款信息'      
      t.string :donor, comment: '捐赠者'      
      t.integer :promoter_id, comment: '劝捐人'      
      t.string :remitter_name, comment: '汇款人姓名'      
      t.integer :remitter_id, comment: '汇款人id'      
      t.integer :voucher_state, comment: '捐赠收据状态'      

      t.timestamps
    end
  end
end