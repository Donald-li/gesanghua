class NewDonation < ActiveRecord::Migration[5.1]
  def change
    create_table :donations, comment: '捐助表' do |t|
      t.integer :donor_id, comment: '捐助人id'
      t.references :owner, polymorphic: true, index: true, comment: '捐助所属模型'
      t.integer :pay_state, comment: '支付状态 1:等待支付 2:支付完成'
      t.integer :voucher_state, comment: '捐赠收据状态'
      t.integer :project_id, comment: '项目id'
      t.integer :project_season_id, comment: '批次/年度id'
      t.integer :project_season_apply_id, comment: '申请id'
      t.integer :project_season_apply_child_id, comment: '申请捐助孩子id'
      t.string :order_no, comment: '订单编号'
      t.string :certificate_no, comment: '捐赠证书编号'
      t.string :title, comment: '标题'
      t.integer :promoter_id, comment: '劝捐人'
      t.integer :team_id, comment: '团队id'
      t.integer :pay_state, comment: '支付状态'
      t.text :pay_result, comment: '支付接口返回的支付接口数据'

      t.timestamps
    end
  end
end
