class AddColumnGradeNameToGshChildGrant < ActiveRecord::Migration[5.1]
  def change
    add_column :gsh_child_grants, :grade_name, :string, comment: '年级名称'
  end
end
