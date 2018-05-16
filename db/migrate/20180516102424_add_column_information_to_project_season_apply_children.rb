class AddColumnInformationToProjectSeasonApplyChildren < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_children, :information, :text, comment: '对外展示的孩子介绍'
  end
end
