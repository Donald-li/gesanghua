class AddTwoColumnsToCampaigns < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :sign_up_state, :integer, comment: '报名状态 1:未开始报名 2:报名中 3:报名结束'
    add_column :campaigns, :campaign_state, :integer, comment: '活动状态 1:活动未开始 2:活动进行中 3:活动已结束'
  end
end
