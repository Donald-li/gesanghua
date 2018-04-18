class CreateProjectSeasonApplyBookshelves < ActiveRecord::Migration[5.1]
  def change
    create_table :project_season_apply_bookshelves, comment: '项目执行年度申请书架表' do |t|
      t.integer :project_id, comment: '关联项目id'
      t.integer :project_season_id, comment: '关联项目执行年度id'
      t.integer :project_season_apply_id, comment: '关联项目执行年度申请id'
      t.integer :gsh_bookshelf_id, comment: '关联格桑花书架id'
      t.string :classname, comment: '班级名'
      t.string :title, comment: '冠名'
      t.decimal :amount, precision: 14, scale: 2, default: 0.0, comment: '筹款金额'
      t.decimal :surplus, precision: 14, scale: 2, default: 0.0, comment: '剩余捐款额'

      t.timestamps
    end
  end
end
