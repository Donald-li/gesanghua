class AddApplicantIdToProjectSeasonApplies < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_applies, :applicant_id, :integer, comment: '申请人id'
  end
end
