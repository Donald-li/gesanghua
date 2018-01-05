class AddNameAndIdCardAndGenderAndNationToTableProjectSeasonApplyChildren < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_children, :phone, :string, comment: '电话'
    add_column :project_season_apply_children, :qq, :string, comment: 'QQ号码'
    add_column :project_season_apply_children, :nation, :integer, comment: '民族'
    add_column :project_season_apply_children, :id_card, :string, comment: '身份证号码'
    add_column :project_season_apply_children, :parent_name, :string, comment: '家长姓名'
    add_column :project_season_apply_children, :description, :text, comment: '描述'
    add_column :project_season_apply_children, :state, :integer, comment: '状态'
    add_column :project_season_apply_children, :approve_state, :integer, comment: '审核状态'
    add_column :project_season_apply_children, :age, :integer, comment: '年龄'
    add_column :project_season_apply_children, :level, :integer, comment: '初中或高中'
    add_column :project_season_apply_children, :grade, :integer, comment: '年级'
    add_column :project_season_apply_children, :gender, :integer, comment: '性别'
    add_column :project_season_apply_children, :school_id, :integer, comment: '学校ID'
  end
end
