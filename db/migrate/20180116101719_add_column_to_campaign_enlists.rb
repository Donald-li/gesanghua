class AddColumnToCampaignEnlists < ActiveRecord::Migration[5.1]
  def change
    add_column :campaign_enlists, :income_source_id, :integer, comment: '收入来源id'
  end
end
