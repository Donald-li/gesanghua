class AddColumnFormToTableCampaigns < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :form, :jsonb, comment: '报名表单定义'
    add_column :campaign_enlists, :form, :jsonb, comment: '报名表单'
  end
end
