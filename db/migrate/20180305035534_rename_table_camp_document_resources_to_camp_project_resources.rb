class RenameTableCampDocumentResourcesToCampProjectResources < ActiveRecord::Migration[5.1]
  def change
    rename_table :camp_document_resources, :camp_project_resources
  end
end
