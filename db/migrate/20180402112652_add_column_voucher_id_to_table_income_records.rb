class AddColumnVoucherIdToTableIncomeRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :income_records, :voucher_id, :integer, comment: '捐赠收据ID'
  end
end
