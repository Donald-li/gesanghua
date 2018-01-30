class AddAppointFundIdToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :appoint_fund_id, :integer, comment: '定向指定财务分类id'
  end
end
