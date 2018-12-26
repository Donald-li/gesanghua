class AddColumnChildPriceToCampaigns < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :child_price, :decimal, precision: 14, scale: 2, default: 0.0, comment: '儿童价'
  end
end
