class AddVoucherStateToIncomeRecord < ActiveRecord::Migration[5.1]
  def change
    add_column :income_records, :voucher_state, :integer, comment: '开票状态'
    add_column :income_records, :title, :string, comment: '收入名称'
  end
end
