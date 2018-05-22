class AddColumnExpenditureLedgerIdToExpenditureRecord < ActiveRecord::Migration[5.1]
  def change
    add_column :expenditure_records, :expenditure_ledger_id, :integer
    add_column :income_sources, :amount, :decimal, precision: 14, scale: 2, default: 0.0, comment: '累计收入'
  end
end
