class AddColumnsInTotalAndOutTotalToIncomeSources < ActiveRecord::Migration[5.1]
  def change
    add_column :income_sources, :in_total, :decimal, precision: 14, scale: 2, default: 0.0, comment: '历史收入'
    add_column :income_sources, :out_total, :decimal, precision: 14, scale: 2, default: 0.0, comment: '历史支出'
  end
end
