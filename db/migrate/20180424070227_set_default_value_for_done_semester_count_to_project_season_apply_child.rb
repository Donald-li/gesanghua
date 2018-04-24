class SetDefaultValueForDoneSemesterCountToProjectSeasonApplyChild < ActiveRecord::Migration[5.1]
  def change
    change_column :project_season_apply_children, :done_semester_count, :integer, default: 0
    ProjectSeasonApplyChild.all.each {|child| child.update(done_semester_count: 0) if child.done_semester_count == nil}
  end
end
