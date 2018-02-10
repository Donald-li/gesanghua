class RemoveColumnFromDonateRecords < ActiveRecord::Migration[5.1]
  def change
    remove_column :donate_records, :donation_id
    add_column :donate_records, :donate_item_id, :integer, comment: '可捐助id'
  end
end
