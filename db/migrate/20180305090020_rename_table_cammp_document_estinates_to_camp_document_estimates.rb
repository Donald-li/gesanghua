class RenameTableCammpDocumentEstinatesToCampDocumentEstimates < ActiveRecord::Migration[5.1]
  def change
    rename_table :cammp_document_estinates, :camp_document_estimates
    rename_table :comp_document_summaries, :camp_document_summaries

    rename_column :camp_document_estimates, :project_id, :project_season_id
    rename_column :camp_document_finances, :project_id, :project_season_id
    rename_column :camp_document_volunteers, :project_id, :project_season_id
    rename_column :camp_document_summaries, :project_id, :project_season_id
    rename_column :camp_project_resources, :project_id, :project_season_id
  end
end
