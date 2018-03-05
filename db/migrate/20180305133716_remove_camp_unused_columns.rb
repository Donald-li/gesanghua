class RemoveCampUnusedColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :camp_project_resources, :project_season_id, :integer
    remove_column :camp_document_summaries, :submit_at, :datetime
    remove_column :camp_document_summaries, :submit_user, :string
  end
end
