class AddColumnRemitterToIncomeRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :income_records, :remitter, :string, comment: '汇款人（用于线下记录）'
  end
end
