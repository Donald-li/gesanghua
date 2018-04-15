class AddColumnVoucherIdToDonations < ActiveRecord::Migration[5.1]
  def change
    add_column :donations, :voucher_id, :integer, comment: '开票记录id'
  end
end
