class AddAmountToDonations < ActiveRecord::Migration[5.1]
  def change
    add_column :donations, :amount, :decimal, precision: 14, scale: 2, default: 0.0, comment: '捐助金额'
  end
end
