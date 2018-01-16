class AddColumnsToCampaigns < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :sign_up_start_time, :datetime, comment: '报名开始时间'
    add_column :campaigns, :number, :integer, comment: '报名限制人数'
    add_column :campaigns, :remark, :string, comment: '报名表备注'
  end
end
