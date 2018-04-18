class AddManyColumnsToProjectSeasonApplyChildren < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_children, :teacher_name, :string, comment: '班主任'
    add_column :project_season_apply_children, :father, :string, comment: '父亲'
    add_column :project_season_apply_children, :father_job, :string, comment: '父亲职业'
    add_column :project_season_apply_children, :mother, :string, comment: '母亲'
    add_column :project_season_apply_children, :mother_job, :string, comment: '母亲职业'
    add_column :project_season_apply_children, :guardian, :string, comment: '监护人'
    add_column :project_season_apply_children, :guardian_relation, :string, comment: '与监护人关系'
    add_column :project_season_apply_children, :guardian_phone, :string, comment: '监护人电话'
    add_column :project_season_apply_children, :address, :string, comment: '家庭住址'
    add_column :project_season_apply_children, :family_income, :decimal, precision: 14, scale: 2, default: 0.0, comment: '家庭年收入'
    add_column :project_season_apply_children, :family_expenditure, :decimal, precision: 14, scale: 2, default: 0.0, comment: '家庭年支出'
    add_column :project_season_apply_children, :income_source, :string, comment: '收入来源'
    add_column :project_season_apply_children, :family_condition, :string, comment: '家庭情况'
    add_column :project_season_apply_children, :brothers, :string, comment: '兄弟姐妹'
  end
end
