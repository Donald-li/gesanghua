class AddColumnToFund < ActiveRecord::Migration[5.1]
  def change
    add_column :funds, :out_total, :decimal, precision: 14, scale: 2, default: 0.0, comment: '历史支出'
  end
end
