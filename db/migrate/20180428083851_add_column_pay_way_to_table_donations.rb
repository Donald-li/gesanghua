class AddColumnPayWayToTableDonations < ActiveRecord::Migration[5.1]
  def change
    add_column :donations, :pay_way, :integer, comment: '支付方式'
  end
end
