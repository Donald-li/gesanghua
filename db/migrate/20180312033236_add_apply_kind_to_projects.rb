class AddApplyKindToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :apply_kind, :integer, default: 1, comment: '申请类型 1:平台分配 2:用户申请'

  end
end
