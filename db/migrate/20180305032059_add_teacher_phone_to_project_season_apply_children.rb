class AddTeacherPhoneToProjectSeasonApplyChildren < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_children, :teacher_phone, :string, comment: '班主任联系方式'
  end
end
