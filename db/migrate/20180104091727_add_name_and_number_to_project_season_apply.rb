class AddNameAndNumberToProjectSeasonApply < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_applies, :name, :string, comment: '名称'
    add_column :project_season_applies, :number, :integer, comment: '配额'
  end
end
