class AddAppointFundIdToCampaigns < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :appoint_fund_id, :integer, comment: '指定财务分类'
  end
end
