class AddReasonToProjectSeasonApplyChildren < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_children, :reason, :string, comment: '结对申请理由'
  end
end
