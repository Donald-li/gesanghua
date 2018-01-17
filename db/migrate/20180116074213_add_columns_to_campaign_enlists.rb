class AddColumnsToCampaignEnlists < ActiveRecord::Migration[5.1]
  def change
    add_column :campaign_enlists, :contact_name, :string, comment: '联系人'
    add_column :campaign_enlists, :contact_phone, :string, comment: '联系电话'
    add_column :campaign_enlists, :payment_state, :integer, comment: '支付状态 1:已支付 2:已取消', default: 1
  end
end
