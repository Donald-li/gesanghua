class AddDonateItemIdToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :donate_item_id, :integer, comment: '捐助项id'
  end
end
