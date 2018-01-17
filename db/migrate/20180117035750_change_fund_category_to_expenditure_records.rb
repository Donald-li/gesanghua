class ChangeFundCategoryToExpenditureRecords < ActiveRecord::Migration[5.1]
  def change
    remove_column :expenditure_records, :fund_category_id, :integer
  end
end
