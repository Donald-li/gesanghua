class AddGshChildIdToDonateRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :donate_records, :gsh_child_id, :integer, comment: '格桑花孩子id'
  end
end
