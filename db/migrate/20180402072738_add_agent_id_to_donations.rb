class AddAgentIdToDonations < ActiveRecord::Migration[5.1]
  def change
    add_column :donations, :agent_id, :integer, comment: '代理人id'
  end
end
