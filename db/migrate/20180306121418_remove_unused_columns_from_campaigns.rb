class RemoveUnusedColumnsFromCampaigns < ActiveRecord::Migration[5.1]
  def change
    remove_column :campaigns, :start_at, :datetime
    remove_column :campaigns, :end_at, :datetime
    remove_column :campaigns, :sign_up_state, :integer
    remove_column :campaigns, :campaign_state, :integer
  end
end
