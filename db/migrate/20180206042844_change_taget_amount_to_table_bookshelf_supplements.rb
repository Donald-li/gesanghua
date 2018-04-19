class ChangeTagetAmountToTableBookshelfSupplements < ActiveRecord::Migration[5.1]
  def change
    remove_column :bookshelf_supplements, :taget_amount
    add_column :bookshelf_supplements, :target_amount, :decimal, precision: 14, scale: 2, default: 0.0, comment: '目标金额'
  end
end
