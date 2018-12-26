class AddColumnAdultNumberAndChildNumberToCampaignEnlist < ActiveRecord::Migration[5.1]
  def change
    add_column :campaign_enlists, :adult_number, :integer, default: 0
    add_column :campaign_enlists, :child_number, :integer, default: 0
    CampaignEnlist.all.each{|enlist| enlist.update(adult_number: enlist.number)}
  end
end
