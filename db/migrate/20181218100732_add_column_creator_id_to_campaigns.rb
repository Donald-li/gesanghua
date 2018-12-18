class AddColumnCreatorIdToCampaigns < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :creator_id, :integer
  end
end
