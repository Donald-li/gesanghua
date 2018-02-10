class CreateDonationUseLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :donation_use_logs, comment: '捐款使用路径' do |t|
      t.integer :income_record_id, comment: '入账记录id'
      t.integer :project_season_apply_id, comment: '项目批次申请id'
      t.integer :donate_record_id, comment: '捐助记录id'
      t.integer :user_id, comment: '用户id'

      t.timestamps
    end
  end
end
