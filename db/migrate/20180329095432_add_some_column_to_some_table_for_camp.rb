class AddSomeColumnToSomeTableForCamp < ActiveRecord::Migration[5.1]
  def change
    remove_column :camp_document_estimates, :project_season_id, :integer
    add_column :camp_document_estimates, :project_season_apply_id, :integer, comment: '探索营申请id'
    add_column :camp_document_estimates, :camp_id, :integer, comment: '探索营id'
    remove_column :camp_document_finances, :project_season_id, :integer
    add_column :camp_document_finances, :project_season_apply_id, :integer, comment: '探索营申请id'
    add_column :camp_document_finances, :camp_id, :integer, comment: '探索营id'
    remove_column :camp_document_summaries, :project_season_id, :integer
    add_column :camp_document_summaries, :project_season_apply_id, :integer, comment: '探索营申请id'
    add_column :camp_document_summaries, :camp_id, :integer, comment: '探索营id'
    remove_column :camp_document_volunteers, :project_season_id, :integer
    add_column :camp_document_volunteers, :project_season_apply_id, :integer, comment: '探索营申请id'
    add_column :camp_document_volunteers, :camp_id, :integer, comment: '探索营id'

    add_column :project_season_applies, :camp_id, :integer, comment: '探索营id'
    add_column :users, :camp_id, :integer, comment: '探索营id'
    add_column :camp_project_resources, :camp_id, :integer, comment: '探索营id'
  end
end
