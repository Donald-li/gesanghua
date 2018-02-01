class ChangeSomeColumnsToBookshelves < ActiveRecord::Migration[5.1]
  def change
    remove_column :project_season_apply_bookshelves, :amount, :decimal
    add_column :project_season_apply_bookshelves, :target_amount, :decimal, precision: 14, scale: 2, default: "0", comment: '目标金额'
    remove_column :project_season_apply_bookshelves, :surplus, :decimal
    add_column :project_season_apply_bookshelves, :present_amount, :decimal, precision: 14, scale: 2, default: "0", comment: '目前已筹金额'
    remove_column :bookshelf_supplements, :balance, :decimal
    add_column :bookshelf_supplements, :present_amount, :decimal, precision: 14, scale: 2, default: "0", comment: '目前已筹金额'
  end
end
