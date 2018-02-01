class CreateBookshelfSupplements < ActiveRecord::Migration[5.1]
  def change
    create_table :bookshelf_supplements do |t|
      t.integer :project_season_apply_bookshelf_id, comment: '书架ID'
      t.integer :project_season_apply_id, comment: '申请ID'
      t.integer :loss, comment: '损耗数量'
      t.integer :upply, comment: '补充数量'
      t.decimal :taget_amount, precision: 14, scale: 2, default: "0", comment: '目标金额'
      t.decimal :balance, precision: 14, scale: 2, default: "0", comment: '剩余金额'
      t.integer :state, comment: '审核状态'
      t.text :describe, comment: '描述'

      t.timestamps
    end
  end
end
