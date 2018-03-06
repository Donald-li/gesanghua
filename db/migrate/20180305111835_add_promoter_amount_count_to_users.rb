class AddPromoterAmountCountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :promoter_amount_count, :decimal, precision: 14, scale: 2, default: "0.0", comment: '累计劝捐额'

  end
end
