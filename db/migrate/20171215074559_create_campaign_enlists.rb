class CreateCampaignEnlists < ActiveRecord::Migration[5.1]
  def change
    create_table :campaign_enlists, comment: '活动用户表' do |t|
      t.integer :campaign_id, comment: '活动ID'
      t.integer :user_id, comment: '用户ID'
      t.integer :number, comment: '报名人数'
      t.string :remark, comment: '备注'
      t.decimal :total, precision: 14, scale: 2, default: "0.0", comment: '合计报名金额'

      t.timestamps
    end
  end
end
