class AddTitleToProjectSeasonApplyBookshelves < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_bookshelves, :school_id, :integer, comment: '学校id'
    add_column :project_season_apply_bookshelves, :province, :string, comment: '省'
    add_column :project_season_apply_bookshelves, :city, :string, comment: '市'
    add_column :project_season_apply_bookshelves, :district, :string, comment: '区/县'
    add_column :project_season_apply_bookshelves, :audit_state, :integer, comment: '审核状态 1:提交 2:通过 3:拒绝'
    add_column :project_season_apply_bookshelves, :show_state, :integer, comment: '显示状态 1:显示 2:隐藏'
    add_column :project_season_apply_bookshelves, :state, :integer, comment: '筹款状态:'
    add_column :project_season_apply_bookshelves, :grade, :integer, comment: '年级'
  end
end
