class AddSomeColumnsToProjectSeasonApplyCampMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_camp_members, :height, :float, comment: '身高'
    add_column :project_season_apply_camp_members, :weight, :float, comment: '体重'
    add_column :project_season_apply_camp_members, :guardian_id_card, :string, comment: '监护人身份证号'
    add_column :project_season_apply_camp_members, :guardian_relation, :string, comment: '监护人关系'
    add_column :project_season_apply_camp_members, :cloth_size, :string, comment: '服装型号'
    add_column :project_season_apply_camp_members, :course_type, :string, comment: '教授课程'
    add_column :project_season_apply_camp_members, :course_grade, :string, comment: '教授年级'
    add_column :project_season_apply_camp_members, :period, :float, comment: '工作时间'
    add_column :project_season_apply_camp_members, :position, :string, comment: '职位'
    add_column :project_season_apply_camp_members, :train_experience, :text, comment: '训练经历'
    add_column :project_season_apply_camp_members, :project_experience, :text, comment: '格桑花项目经验'
    add_column :project_season_apply_camp_members, :honor_experience, :text, comment: '荣誉'
  end
end
