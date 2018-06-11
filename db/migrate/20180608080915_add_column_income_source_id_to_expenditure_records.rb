class AddColumnIncomeSourceIdToExpenditureRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :expenditure_records, :income_source_id, :integer
  end
end
