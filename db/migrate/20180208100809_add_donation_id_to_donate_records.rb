class AddDonationIdToDonateRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :donate_records, :donation_id, :integer, comment: '可捐助id'
  end
end
