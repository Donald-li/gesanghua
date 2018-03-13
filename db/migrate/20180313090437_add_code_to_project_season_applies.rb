class AddCodeToProjectSeasonApplies < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_applies, :code, :string, comment: 'code'
  end
end
