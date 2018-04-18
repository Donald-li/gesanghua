class AddAmountTotalToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :donate_record_amount_count, :decimal, precision: 14, scale: 2, default: 0.0, comment: '累计捐助金额'
  end
end
