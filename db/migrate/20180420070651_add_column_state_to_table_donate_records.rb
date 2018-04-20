class AddColumnStateToTableDonateRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :donate_records, :state, :integer, comment: '状态'
    DonateRecord.update_all(state: 1)
  end
end
