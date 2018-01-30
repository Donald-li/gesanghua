class AddColumnsToProjectSeasonApply < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_applies, :girl_number, :integer, comment: '申请女生人数'
    add_column :project_season_applies, :boy_number, :integer, comment: '申请男生人数'
    add_column :project_season_applies, :address, :string, comment: '详细地址'
    add_column :project_season_applies, :consignee, :string, comment: '收货人'
    add_column :project_season_applies, :consignee_phone, :string, comment: '收货人联系电话'
    add_column :project_season_applies, :approve_state, :integer, comment: '审核状态 1:待审核 2:通过 3:不通过'
  end
end
